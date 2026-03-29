{
  config,
  lib,
  pkgs,
  ...
}:
let
  backgroundImagePath = "${config.home.homeDirectory}/.config/background";
  backgroundImageExists = builtins.pathExists backgroundImagePath;
in
{
  config = lib.mkMerge [
    { stylix.enable = lib.mkDefault true; }
    (lib.mkIf config.stylix.enable {
      stylix = {
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
        cursor = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 28;
        };
        fonts = {
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
          sansSerif = {
            package = pkgs.ibm-plex;
            name = "IBM Plex Sans";
          };
          serif = {
            package = pkgs.ibm-plex;
            name = "IBM Plex Serif";
          };
          monospace = {
            package = pkgs.nerd-fonts.hack;
            name = "Hack Nerd Font Mono";
          };
        };
        image = lib.mkDefault (config.lib.stylix.pixel "base0D");
      };
    })
    (lib.mkIf (config.stylix.enable && backgroundImageExists) {
      stylix.image = builtins.fetchurl { url = "file://${backgroundImagePath}"; };
    })
  ];
}
