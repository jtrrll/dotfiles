{ inputs, self, ... }:
{
  imports = [ inputs.devenv.flakeModule ];

  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      devenv = {
        modules = (lib.attrValues self.modules.devenv) ++ [
          {
            containers = lib.mkForce { }; # Workaround to remove containers from flake checks.
          }
          {
            claude.code.enable = true;
            justix.mcpServer.enable = true;
          }
        ];
        shells.default = {
          enterShell = lib.getExe (
            pkgs.writeShellApplication rec {
              meta.mainProgram = name;
              name = "splashScreen";
              runtimeInputs = [
                pkgs.lolcat
                pkgs.uutils-coreutils-noprefix
                self'.packages.splash
              ];
              text = ''
                splash
                printf "\033[0;1;36mDEVSHELL ACTIVATED\033[0m\n"
              '';
            }
          );

          git-hooks = {
            default_stages = [ "pre-push" ];
            hooks = {
              actionlint.enable = true;
              check-added-large-files = {
                enable = true;
                stages = [ "pre-commit" ];
              };
              check-json.enable = true;
              check-yaml.enable = true;
              deadnix.enable = true;
              detect-private-keys = {
                enable = true;
                stages = [ "pre-commit" ];
              };
              end-of-file-fixer.enable = true;
              flake-checker.enable = true;
              fmt = {
                enable = true;
                entry = "just fmt";
                name = "fmt";
                pass_filenames = false;
              };
              markdownlint = {
                enable = true;
                settings.configuration = {
                  MD013.line_length = 120;
                };
              };
              mixed-line-endings.enable = true;
              nil.enable = true;
              no-commit-to-branch = {
                enable = true;
                stages = [ "pre-commit" ];
              };
              ripsecrets = {
                enable = true;
                stages = [ "pre-commit" ];
              };
              shellcheck = {
                enable = true;
                excludes = [ ".envrc" ];
              };
              shfmt.enable = true;
              statix = {
                enable = true;
                settings.ignore = [ "hardware_configuration.nix" ];
              };
            };
          };

          languages.nix = {
            enable = true;
            lsp.package = pkgs.nixd;
          };

          packages = [
            pkgs.nushell
          ];
        };
      };
    };
}
