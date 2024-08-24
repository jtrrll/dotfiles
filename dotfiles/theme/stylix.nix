{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.theme.enable {
    stylix =
      {
        enable = builtins.pathExists config.dotfiles.theme.backgroundImage;
        cursor = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 28;
        };
        fonts = {
          emoji = {
            package = pkgs.noto-fonts-emoji;
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
            package = pkgs.nerdfonts.override {fonts = ["Hack"];};
            name = "Hack Nerd Font Mono";
          };
        };
        image = builtins.fetchurl {url = "file://${config.dotfiles.theme.backgroundImage}";};
      }
      // (
        if (config.dotfiles.theme.base16Scheme != null)
        then {inherit (config.dotfiles.theme) base16Scheme;}
        else {}
      );
  };
}
