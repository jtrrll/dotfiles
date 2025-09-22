{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.theme.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.ibm-plex
      pkgs.monocraft
      pkgs.nerd-fonts.hack
    ];
  };
}
