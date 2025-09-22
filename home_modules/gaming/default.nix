{ lib' }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.gaming.enable {
    home = {
      file.gameLibrary = {
        target = "game_library/README.md";
        text = ''
          # ~/game_library

          A library directory for games.

        '';
      };
      packages = lib'.filterAvailable pkgs.stdenv.system [
        pkgs.prismlauncher
        pkgs.steam-rom-manager
      ];
    };
    programs.vesktop.enable = true;
  };

  options.jtrrllDotfiles.gaming = {
    enable = lib.mkEnableOption "jtrrll's gaming configuration";
  };
}
