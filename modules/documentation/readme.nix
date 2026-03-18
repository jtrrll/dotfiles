{ inputs, self, ... }:
{
  imports = [ inputs.files.flakeModules.default ];

  config.perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      options = config.packages.options.override {
        homeModules = lib.attrValues self.homeModules;
      };
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
