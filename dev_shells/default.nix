{ inputs, ... }:
{
  imports = [ inputs.devenv.flakeModule ];
  perSystem =
    {
      inputs',
      lib,
      pkgs,
      self',
      ...
    }:
    {
      devenv = {
        modules = [
          inputs.justix.devenvModules.default
          {
            containers = lib.mkForce { }; # Workaround to remove containers from flake checks.
          }
          {
            justix = {
              enable = true;
              justfile = {
                recipes = {
                  default = {
                    attributes = {
                      default = true;
                      doc = "Lists available recipes";
                      private = true;
                    };
                    commands = "@just --list";
                  };
                  fmt = {
                    attributes.doc = "Formats and lints files";
                    commands = ''
                      @find "{{ paths }}" ! -path '*/.*' -exec ${lib.getExe inputs'.snekcheck.packages.default} --fix {} +
                      @nix fmt -- {{ paths }}
                    '';
                    parameters = [ "*paths='.'" ];
                  };
                };
              };
            };
          }
          (
            { config, ... }:
            {
              justix.justfile.recipes =
                let
                  pkgToRecipe = pkg: {
                    attributes.doc = pkg.meta.description;
                    commands = "@${lib.getExe pkg} {{ args }}";
                    parameters = [ "*args" ];
                  };
                  rootPath = config.devenv.root;
                in
                {
                  activate = pkgToRecipe (self'.scripts.activate.override { inherit rootPath; });
                  update-docs = pkgToRecipe self'.scripts.update-docs;
                };
            }
          )
        ];
        shells.default = {
          enterShell = lib.getExe (
            pkgs.writeShellApplication rec {
              meta.mainProgram = name;
              name = "splashScreen";
              runtimeInputs = [
                pkgs.lolcat
                pkgs.uutils-coreutils-noprefix
                self'.scripts.splash
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
              markdownlint.enable = true;
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
