{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.devenv.flakeModule
  ];

  perSystem = {
    config,
    lib,
    pkgs,
    system,
    ...
  }: {
    devenv = {
      modules = [
        inputs.env-help.devenvModule
      ];
      shells.default = {
        enterShell = "${pkgs.writeShellApplication {
          name = "splashScreen";
          runtimeInputs = [
            pkgs.lolcat
            pkgs.uutils-coreutils-noprefix
          ];
          text = ''
            printf "    ▓█████▄  ▒█████  ▄▄▄█████▓  █████▒██▓ ██▓    ▓█████   ██████
                ▒██▀ ██▌▒██▒  ██▒▓  ██▒ ▓▒▓██   ▒▓██▒▓██▒    ▓█   ▀ ▒██    ▒
                ░██   █▌▒██░  ██▒▒ ▓██░ ▒░▒████ ░▒██▒▒██░    ▒███   ░ ▓██▄
                ░▓█▄   ▌▒██   ██░░ ▓██▓ ░ ░▓█▒  ░░██░▒██░    ▒▓█  ▄   ▒   ██▒
            ██▓ ░▒████▓ ░ ████▓▒░  ▒██▒ ░ ░▒█░   ░██░░██████▒░▒████▒▒██████▒▒
            ▒▓▒  ▒▒▓  ▒ ░ ▒░▒░▒░   ▒ ░░    ▒ ░   ░▓  ░ ▒░▓  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
            ░▒   ░ ▒  ▒   ░ ▒ ▒░     ░     ░      ▒ ░░ ░ ▒  ░ ░ ░  ░░ ░▒  ░ ░
            ░    ░ ░  ░ ░ ░ ░ ▒    ░       ░ ░    ▒ ░  ░ ░      ░   ░  ░  ░
              ░     ░        ░ ░                   ░      ░  ░   ░  ░      ░
              ░   ░\n" | lolcat
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

        scripts = {
          activate = {
            description = "Activates a configuration.";
            exec = let
              configurations = builtins.attrNames self.homeManagerConfigurations;
            in "${pkgs.writeShellApplication {
              name = "activate";
              runtimeInputs = [
                pkgs.gum
                pkgs.home-manager
                pkgs.uutils-coreutils-noprefix
              ];
              text = ''
                if [[ "$#" -eq 1 ]]; then
                  config="$1"
                elif [[ "$#" -eq 0 ]]; then
                  config=$(printf "%s" "${builtins.concatStringsSep "\n" configurations}" | gum filter)
                else
                  echo "Usage: $(basename "$0") <config>"
                  exit 1
                fi

                home-manager switch -b bak --flake "$PROJECT_ROOT"#"$config" --impure
              '';
            }}/bin/activate $@";
          };
          generate-docs = {
            description = "Inserts options documentation for the dotfiles module into the README.";
            exec = let
              eval = lib.evalModules {
                modules = [
                  self.homeManagerModules.dotfiles
                  {dotfiles.username = "\${config.dotfiles.username}";}
                  {options.programs.__stub = lib.mkSinkUndeclaredOptions {};}
                  {
                    config._module = {
                      check = false;
                      dotfiles.username = "";
                      lib.stylix = {};
                      stylix.targets = {};
                    };
                  }
                ];
              };
              flattenOptions = prefix: opts:
                lib.foldlAttrs (
                  acc: name: opt: let
                    fullName =
                      if prefix == ""
                      then name
                      else "${prefix}.${name}";
                    result =
                      if opt ? type
                      then {"${fullName}" = opt;}
                      else flattenOptions fullName opt;
                  in
                    acc // result
                ) {}
                opts;
              options = flattenOptions "dotfiles" eval.options.dotfiles;
              optionsMarkdown = lib.concatStringsSep "\n" (lib.mapAttrsToList
                (
                  name: opt: let
                    defaultLine = lib.optionalString (opt ? default) "* Default: `${builtins.toJSON opt.default}`\n";
                    descriptionLine = lib.optionalString (opt ? description) "* Description: ${opt.description}\n";
                    exampleLine = lib.optionalString (opt ? example) "* Example: `${builtins.toJSON opt.example}`\n";
                    typeLine = lib.optionalString (opt ? type && opt.type ? description) "* Type: `${opt.type.description}`";
                  in ''
                    ### `${name}`

                    ${defaultLine}${descriptionLine}${exampleLine}${typeLine}
                  ''
                )
                options);
            in "${pkgs.writeShellApplication {
              name = "generate-docs";
              runtimeInputs = [
                pkgs.gawk
                pkgs.uutils-coreutils-noprefix
              ];
              text = ''
                cat <<'EOF' > options.md
                ${optionsMarkdown}
                EOF

                awk '/<!-- BEGIN OPTIONS -->/{flag=1;print;system("cat options.md");next}/<!-- END OPTIONS -->/{flag=0} !flag' README.md > README.tmp
                mv README.tmp README.md
                rm options.md
              '';
            }}/bin/generate-docs";
          };
          lint = {
            description = "Lints the project.";
            exec = "${pkgs.writeShellApplication {
              name = "lint";
              runtimeInputs = [
                inputs.snekcheck.packages.${system}.snekcheck
              ];
              text = ''
                snekcheck --fix "$PROJECT_ROOT" && \
                nix fmt "$PROJECT_ROOT" -- --quiet
              '';
            }}/bin/lint";
          };
        };
      };
    };
  };
}
