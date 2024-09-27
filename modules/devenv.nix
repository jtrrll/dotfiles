{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.devenv.flakeModule
  ];
  perSystem = {pkgs, ...}: {
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

        packages = [
          pkgs.commitizen
        ];

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
            commitizen.enable = true;
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
            statix.enable = true;
          };
        };

        scripts = {
          activate = {
            description = "Activates a configuration.";
            exec = let
              configurations = builtins.attrNames self.homeConfigurations;
            in ''
              CONFIG=$(${pkgs.uutils-coreutils-noprefix}/bin/printf "%s" "${builtins.concatStringsSep "\n" configurations}" \
              | ${pkgs.gum}/bin/gum filter)

              ${pkgs.gum}/bin/gum spin --show-error --spinner line --title "Activating $CONFIG..." -- \
              ${pkgs.home-manager}/bin/home-manager switch -b backup --flake "$DEVENV_ROOT"#"$CONFIG" --impure
            '';
          };
          lint = {
            description = "Lints the project.";
            exec = ''
              ${pkgs.gum}/bin/gum spin --show-error --spinner line --title "nix fmt" -- nix fmt
            '';
          };
        };
      };
    };
  };
}
