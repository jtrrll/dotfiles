{inputs, ...}: {
  imports = [
    inputs.devenv.flakeModule
  ];

  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
    devenv = {
      modules = [
        inputs.env-help.devenvModule
      ];
      shells.default = {
        containers = lib.mkForce {}; # Workaround to remove containers from flake checks.
        enterShell = "${pkgs.writeShellApplication {
          name = "splashScreen";
          runtimeInputs = [
            pkgs.lolcat
            pkgs.uutils-coreutils-noprefix
            config.scripts.splash
          ];
          text = ''
            splash
            printf "\033[0;1;36mDEVSHELL ACTIVATED\033[0m\n"
          '';
        }}/bin/splashScreen";

        env.PROJECT_ROOT = config.devenv.shells.default.env.DEVENV_ROOT;

        env-help.enable = true;

        git-hooks = {
          default_stages = ["pre-push"];
          hooks = {
            actionlint.enable = true;
            alejandra.enable = true;
            check-added-large-files = {
              enable = true;
              stages = ["pre-commit"];
            };
            check-json.enable = true;
            check-yaml.enable = true;
            deadnix.enable = true;
            detect-private-keys = {
              enable = true;
              stages = ["pre-commit"];
            };
            end-of-file-fixer.enable = true;
            flake-checker.enable = true;
            lint = {
              enable = true;
              entry = "lint";
              name = "lint";
              pass_filenames = false;
            };
            markdownlint.enable = true;
            mixed-line-endings.enable = true;
            nil.enable = true;
            no-commit-to-branch = {
              enable = true;
              stages = ["pre-commit"];
            };
            ripsecrets = {
              enable = true;
              stages = ["pre-commit"];
            };
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;
          };
        };

        languages.nix.enable = true;

        scripts = builtins.addErrorContext "while building devenv scripts" (lib.mapAttrs (_: pkg: {
            inherit (pkg.meta) description;
            exec = "${pkg}/bin/${pkg.name} $@";
          })
          config.scripts);
      };
    };
  };
}
