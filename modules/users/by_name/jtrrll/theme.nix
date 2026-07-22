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
        base16Scheme = {
          system = "base16";
          name = "VS Code Dark Modern";
          variant = "dark";
          palette = {
            base00 = "#010409";
            base01 = "#181818";
            base02 = "#1f1f1f";
            base03 = "#6e7681";
            base04 = "#808080";
            base05 = "#cccccc";
            base06 = "#e5e5e5";
            base07 = "#f8f8f8";
            base08 = "#f44747";
            base09 = "#ce9178";
            base0A = "#dcdcaa";
            base0B = "#6a9955";
            base0C = "#9cdcfe";
            base0D = "#569cd6";
            base0E = "#c586c0";
            base0F = "#cd9731";
          };
        };
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
        opacity = {
          popups = 0.95;
        };
      };
    })
    (lib.mkIf (config.stylix.enable && backgroundImageExists) {
      stylix.image = builtins.fetchurl { url = "file://${backgroundImagePath}"; };
    })
  ];
}
