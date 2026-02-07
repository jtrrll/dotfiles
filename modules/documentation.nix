{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  perSystem =
    { pkgs, ... }:
    {
      packages = rec {
        options =
          pkgs.callPackage
            (
              {
                homeModules,
                lib,
                writeTextFile,
              }:
              let
                eval = lib.evalModules {
                  modules = (lib.attrValues homeModules) ++ [
                    {
                      options.home = {
                        username = lib.mkOption {
                          default = "\${config.home.username}";
                          type = lib.types.str;
                        };
                        homeDirectory = lib.mkOption {
                          type = lib.types.path;
                        };
                      };
                    }
                    { options.programs.__stub = lib.mkSinkUndeclaredOptions { }; }
                    {
                      config._module = {
                        check = false;
                        lib.stylix = { };
                        stylix.targets = { };
                      };
                    }
                  ];
                };
                flattenOptions =
                  prefix: opts:
                  lib.foldlAttrs (
                    acc: name: opt:
                    let
                      fullName = if prefix == "" then name else "${prefix}.${name}";
                      result = if opt ? type then { "${fullName}" = opt; } else flattenOptions fullName opt;
                    in
                    acc // result
                  ) { } opts;
                options = flattenOptions "dotfiles" eval.options.dotfiles;
                optionsMarkdown = lib.concatStringsSep "\n" (
                  lib.mapAttrsToList (
                    name: opt:
                    let
                      defaultLine =
                        lib.optionalString (opt ? default)
                          "* Default: `${lib.generators.toJSON { } opt.default}`\n";
                      descriptionLine = lib.optionalString (opt ? description) "* Description: ${opt.description}\n";
                      exampleLine =
                        lib.optionalString (opt ? example)
                          "* Example: `${lib.generators.toJSON { } opt.example}`\n";
                      typeLine = lib.optionalString (
                        opt ? type && opt.type ? description
                      ) "* Type: `${opt.type.description}`";
                    in
                    ''
                      ### `${name}`

                      ${defaultLine}${descriptionLine}${exampleLine}${typeLine}
                    ''
                  ) options
                );
              in
              writeTextFile {
                meta = {
                  description = "Options documentation for the dotfiles module";
                  homepage = "https://github.com/jtrrll/dotfiles";
                  license = lib.licenses.mit;
                };
                name = "options.md";
                text = optionsMarkdown;
              }
            )
            {
              inherit (self) homeModules;
            };
        update-docs = pkgs.callPackage (
          {
            bashInteractive,
            gawk,
            options,
            uutils-coreutils-noprefix,
            vhs,
            writeShellApplication,
          }:
          writeShellApplication rec {
            meta = {
              description = "Updates project documentation in the README.";
              mainProgram = name;
            };
            name = "update-docs";
            runtimeInputs = [
              bashInteractive
              gawk
              uutils-coreutils-noprefix
              vhs
            ];
            text = ''
              awk '/<!-- BEGIN OPTIONS -->/{flag=1;print;system("cat ${options}");next}/<!-- END OPTIONS -->/{flag=0} !flag' README.md > README.tmp
              mv README.tmp README.md
              printf "Updated README.md with options documentation\n"

              cat <<EOF | vhs -
              Output demo.gif

              Set FontFamily "Hack Nerd Font Mono"
              Set FontSize 28
              Set Padding 10
              Set Theme "catppuccin-frappe"
              Set TypingSpeed 100ms

              Set Width 800
              Set Height 450

              Require nix

              Sleep 1s

              Type "nix run github:jtrrll/dotfiles home"
              Sleep 1s
              Enter

              Wait+Screen /Select/
              Sleep 2s
              Down
              Sleep 500ms
              Up
              Sleep 500ms
              Enter

              Sleep 5s
              EOF
              printf "Updated demo.gif\n"
            '';
          }
        ) { inherit options; };
      };
    };
}
