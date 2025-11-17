{ inputs, ... }:
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
      devenv = builtins.addErrorContext "while defining devenv" {
        modules = [
          {
            containers = lib.mkForce { }; # Workaround to remove containers from flake checks.
          }
          (
            { config, ... }:
            {
              scripts = builtins.addErrorContext "while defining devenv scripts" (
                let
                  pkgToScript = pkg: {
                    inherit (pkg.meta) description;
                    exec = "${lib.getExe pkg} $@";
                  };
                  rootPath = config.devenv.root;
                in
                with self'.scripts;
                {
                  activate = pkgToScript (activate.override { inherit rootPath; });
                  lint = pkgToScript (lint.override { inherit rootPath; });
                  update-docs = pkgToScript update-docs;
                }
              );
            }
          )
        ];
        shells.default = builtins.addErrorContext "while defining default devenv shell" {
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

          languages.nix.enable = true;
        };
      };
    };
}
