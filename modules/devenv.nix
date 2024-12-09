{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.devenv.flakeModule
  ];

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    devenv = {
      modules = [
        inputs.env-help.devenvModule
      ];
      shells.default = {
        enterShell = ''
          printf "    ▓█████▄  ▒█████  ▄▄▄█████▓  █████▒██▓ ██▓    ▓█████   ██████
              ▒██▀ ██▌▒██▒  ██▒▓  ██▒ ▓▒▓██   ▒▓██▒▓██▒    ▓█   ▀ ▒██    ▒
              ░██   █▌▒██░  ██▒▒ ▓██░ ▒░▒████ ░▒██▒▒██░    ▒███   ░ ▓██▄
              ░▓█▄   ▌▒██   ██░░ ▓██▓ ░ ░▓█▒  ░░██░▒██░    ▒▓█  ▄   ▒   ██▒
          ██▓ ░▒████▓ ░ ████▓▒░  ▒██▒ ░ ░▒█░   ░██░░██████▒░▒████▒▒██████▒▒
          ▒▓▒  ▒▒▓  ▒ ░ ▒░▒░▒░   ▒ ░░    ▒ ░   ░▓  ░ ▒░▓  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
          ░▒   ░ ▒  ▒   ░ ▒ ▒░     ░     ░      ▒ ░░ ░ ▒  ░ ░ ░  ░░ ░▒  ░ ░
          ░    ░ ░  ░ ░ ░ ░ ▒    ░       ░ ░    ▒ ░  ░ ░      ░   ░  ░  ░
            ░     ░        ░ ░                   ░      ░  ░   ░  ░      ░
            ░   ░\n" | ${pkgs.lolcat}/bin/lolcat
          printf "\033[0;1;36mDEVSHELL ACTIVATED\033[0m\n"
        '';

        env-help.enable = true;

        languages = {
          nix.enable = true;
        };

        pre-commit = {
          default_stages = ["pre-push"];
          hooks = {
            actionlint.enable = true;
            alejandra.enable = true;
            check-added-large-files = {
              enable = true;
              stages = ["pre-commit"];
            };
            check-yaml.enable = true;
            deadnix.enable = true;
            detect-private-keys = {
              enable = true;
              stages = ["pre-commit"];
            };
            end-of-file-fixer.enable = true;
            flake-checker.enable = true;
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
            snekcheck = {
              enable = true;
              entry = "${inputs.snekcheck.packages.${system}.snekcheck}/bin/snekcheck";
              name = "snekcheck";
            };
            statix.enable = true;
          };
        };

        scripts = {
          activate = {
            description = "Activates a configuration.";
            exec = let
              configurations = builtins.attrNames self.homeConfigurations;
            in ''
              config=$(${pkgs.uutils-coreutils-noprefix}/bin/printf "%s" "${builtins.concatStringsSep "\n" configurations}" \
              | ${pkgs.gum}/bin/gum filter)

              ${pkgs.gum}/bin/gum spin --show-error --spinner line --title "Activating $config..." -- \
                ${pkgs.home-manager}/bin/home-manager switch -b backup --flake "$DEVENV_ROOT"#"$config" --impure
            '';
          };
          lint = {
            description = "Lints the project.";
            exec = ''
              ${pkgs.gum}/bin/gum spin --show-error --spinner line --title "nix fmt" -- nix fmt
              ${pkgs.gum}/bin/gum spin --show-error --spinner line --title "snekcheck" -- \
                ${inputs.snekcheck.packages.${system}.snekcheck}/bin/snekcheck "$DEVENV_ROOT"
            '';
          };
        };
      };
    };
  };
}
