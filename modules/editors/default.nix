{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.editors =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        (import ./neovim { inherit (inputs.nixvim.homeModules) nixvim; })
        ./zed.nix
      ];

      options.dotfiles.editors = {
        indentWidth = lib.mkOption {
          default = 2;
          description = "The number of spaces per indent.";
          example = 4;
          type = lib.types.ints.unsigned;
        };
        lineLengthRulers = lib.mkOption {
          default = [
            100
            120
          ];
          description = "The columns to place vertical lines on.";
          example = [ 80 ];
          type = lib.types.listOf lib.types.ints.unsigned;
        };
        linesAroundCursor = lib.mkOption {
          default = 8;
          description = "The number of lines to show above and below the cursor.";
          example = 2;
          type = lib.types.ints.unsigned;
        };
        neovim.enable = lib.mkEnableOption "jtrrll's Neovim configuration";
        zed.enable = lib.mkEnableOption "jtrrll's Zed configuration";
      };

      config.home.packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.edit
      ];
    };
  perSystem =
    { lib, pkgs, ... }:
    {
      packages.edit =
        (pkgs.writers.writeNuBin "edit" { } (lib.readFile ./edit.nu)).overrideAttrs
          (oldAttrs: {
            meta = (oldAttrs.meta or { }) // {
              description = "Launches a text editor.";
            };
          });
    };
}
