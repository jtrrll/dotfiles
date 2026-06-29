{
  config,
  lib,
  ...
}:
{
  config.perSystem =
    { pkgs, ... }:
    let
      yaml = pkgs.formats.yaml { };

      nixInstallerConf = lib.concatStringsSep "\n" [
        "allow-import-from-derivation = false"
        "extra-substituters = https://devenv.cachix.org https://install.determinate.systems https://nix-community.cachix.org"
        "extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      freeDiskSpaceStep = {
        name = "Free disk space";
        uses = "endersonmenezes/free-disk-space@v3";
        "with" = {
          remove_dotnet = true;
          remove_haskell = true;
          remove_packages = "azure-cli microsoft-edge-stable google-chrome-stable firefox postgresql* *llvm* mysql*";
          testing = false;
        };
      };

      nixInstallerStep = {
        uses = "DeterminateSystems/nix-installer-action@v22";
        "with".extra-conf = nixInstallerConf;
      };

      checkoutStep = {
        uses = "actions/checkout@v6";
      };

      uploadEvalStatsStep = artifactName: {
        name = "Upload Nix evaluation statistics";
        uses = "actions/upload-artifact@v7";
        "with" = {
          name = artifactName;
          path = "nix_eval_stats.json";
        };
      };

      evalStatsEnv = {
        NIX_SHOW_STATS = 1;
        NIX_SHOW_STATS_PATH = "nix_eval_stats.json";
      };

      generated = yaml.generate "ci.yaml" {
        name = "CI";
        "on" = {
          pull_request.branches = [ "*" ];
          push.branches = [ "main" ];
          schedule = [ { cron = "0 06 * * MON"; } ];
          workflow_dispatch = { };
        };
        concurrency = {
          cancel-in-progress = true;
          group = "\${{ github.workflow }}-\${{ github.ref }}";
        };
        env.NIXPKGS_ALLOW_UNFREE = 1;
        jobs = {
          build-home-configuration = {
            name = "Build Home Manager configuration";
            strategy = {
              fail-fast = false;
              matrix.include = lib.concatMap (
                configuration:
                map (os: { inherit configuration os; }) [
                  "ubuntu-latest"
                  "macos-latest"
                ]
              ) (builtins.attrNames config.flake.homeConfigurations);
            };
            runs-on = "\${{ matrix.os }}";
            steps = [
              (freeDiskSpaceStep // { "if" = "runner.os == 'Linux'"; })
              checkoutStep
              nixInstallerStep
              {
                name = "Build \${{ matrix.configuration }} configuration";
                env = evalStatsEnv;
                run = "nix build --impure .#homeConfigurations.\${{ matrix.configuration }}.activationPackage";
              }
              (uploadEvalStatsStep "nix-eval-stats-home-\${{ matrix.configuration }}-\${{ matrix.os }}")
            ];
          };
          build-nixos-configuration = {
            name = "Build NixOS configuration";
            strategy = {
              fail-fast = false;
              matrix.include = map (configuration: {
                inherit configuration;
                os = "ubuntu-latest";
              }) (builtins.attrNames config.flake.nixosConfigurations);
            };
            runs-on = "\${{ matrix.os }}";
            steps = [
              freeDiskSpaceStep
              checkoutStep
              nixInstallerStep
              {
                name = "Build \${{ matrix.configuration }} configuration";
                env = evalStatsEnv;
                run = "nix build --impure .#nixosConfigurations.\${{ matrix.configuration }}.config.system.build.toplevel";
              }
              (uploadEvalStatsStep "nix-eval-stats-nixos-\${{ matrix.configuration }}")
            ];
          };
          check = {
            name = "Check";
            runs-on = "ubuntu-latest";
            steps = [
              checkoutStep
              nixInstallerStep
              { uses = "DeterminateSystems/flake-checker-action@v12"; }
              {
                name = "Check flake";
                env = evalStatsEnv;
                run = "nix run github:Mic92/nix-fast-build -- --flake .#checks.x86_64-linux --impure --skip-cached --stream-json-lines --select 'checks: let lib = (builtins.getFlake \"nixpkgs\").lib; exclude = n: lib.hasPrefix \"nixosConfigurations:\" n || lib.hasPrefix \"homeConfigurations:\" n; in lib.filterAttrs (n: _: !exclude n) checks'";
              }
              (uploadEvalStatsStep "nix-eval-stats-check")
            ];
          };
        };
      };
    in
    {
      config.files.file.".github/workflows/ci.yaml".source =
        pkgs.runCommand "ci.yaml" { nativeBuildInputs = [ pkgs.yq-go ]; }
          ''
            yq '
              pick(["name", "on", "concurrency", "env", "jobs"]) |
              .jobs[] |= pick(["name", "strategy", "runs-on", "steps"]) |
              .jobs[].steps[] |= pick(["name", "if", "uses", "with", "env", "run"])
            ' ${generated} > $out
          '';
    };
}
