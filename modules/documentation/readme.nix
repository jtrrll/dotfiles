{ config, inputs, ... }:
{
  imports = [ inputs.files.flakeModules.default ];

  config.perSystem =
    let
      inherit (config.flake) homeModules;
    in
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      eval = lib.evalModules {
        modules =
          lib.attrValues (
            removeAttrs homeModules [
              "glance"
            ]
          )
          ++ [
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
                args.pkgs = pkgs;
                check = false;
              };
            }
          ];
      };
      optionsMarkdown = lib.concatStringsSep "\n" (
        map
          (
            opt:
            let
              inherit (opt) name;
              renderValue =
                v:
                if v ? _type && v._type == "literalExpression" then
                  v.text
                else if v ? _type && v._type == "literalMD" then
                  v.text
                else
                  lib.generators.toJSON { } v;
              default = if opt ? default then renderValue opt.default else null;
              defaultLine = lib.optionalString (default != null) "* Default: `${default}`\n";
              descriptionLine = lib.optionalString (
                opt ? description && opt.description != null
              ) "* Description: ${opt.description}\n";
              exampleLine = lib.optionalString (opt ? example) "* Example: `${renderValue opt.example}`\n";
              typeLine = lib.optionalString (
                opt ? type && opt.type ? description
              ) "* Type: `${opt.type.description}`";
            in
            "### `${name}`\n\n${defaultLine}${descriptionLine}${exampleLine}${typeLine}"
          )
          (
            lib.filter (
              opt:
              !(
                lib.hasPrefix "_module" opt.name
                || lib.hasPrefix "programs.__stub" opt.name
                || lib.hasPrefix "home." opt.name
              )
            ) (lib.optionAttrSetToDocList eval.options)
          )
      );
      options = pkgs.writeText "options.md" optionsMarkdown;
    in
    {
      config = {
        apps.update-demo =
          let
            pkg = pkgs.callPackage (
              {
                bashInteractive,
                uutils-coreutils-noprefix,
                vhs,
                writeShellApplication,
              }:
              writeShellApplication rec {
                meta = {
                  inherit (vhs.meta) platforms;
                  description = "Updates the demo gif";
                  mainProgram = name;
                };
                name = "update-demo";
                runtimeInputs = [
                  bashInteractive
                  uutils-coreutils-noprefix
                  vhs
                ];
                text = ''
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
            ) { };
          in
          {
            meta.description = pkg.meta.description;
            program = pkg;
            type = "app";
          };
        devenv.modules = [ { packages = [ config.files.writer.drv ]; } ];
        files.files = [
          {
            path_ = "README.md";
            drv =
              let
                header = pkgs.writeText "README-header.md" ''
                  # ~/.dotfiles

                  <!-- markdownlint-disable MD013 -->
                  ![CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/ci.yaml?branch=main&label=ci&logo=github)
                  ![License](https://img.shields.io/github/license/jtrrll/dotfiles?label=license&logo=googledocs&logoColor=white)
                  <!-- markdownlint-enable MD013 -->

                  My dotfiles collection for configuring frequently used programs.
                  Managed via [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager)

                  ![Demo](./demo.gif)

                  ## Usage

                  1. [Install Nix](https://zero-to-nix.com/start/install)
                  2. Activate a configuration interactively by running the following:

                     ```sh
                     nix run github:jtrrll/dotfiles home
                     ```

                  ## Options

                '';
              in
              pkgs.runCommand "README.md" { } ''
                cat ${header} ${options} > $out
              '';
          }
        ];
      };
    };
}
