{
  config,
  lib,
  pkgs,
  ...
}:
let
  backgroundImageExists = builtins.pathExists config.dotfiles.theme.backgroundImage;
  schemeDefined = config.dotfiles.theme.base16Scheme != null;
in
{
  config = lib.mkIf config.dotfiles.theme.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = backgroundImageExists || schemeDefined;
            message = "either a valid background image or base16 scheme must be defined.";
          }
        ];
        stylix = {
          enable = true;
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
      }
      (lib.mkIf backgroundImageExists {
        stylix.image = builtins.fetchurl { url = "file://${config.dotfiles.theme.backgroundImage}"; };
      })
      (lib.mkIf schemeDefined {
        stylix = {
          inherit (config.dotfiles.theme) base16Scheme;
        };
      })
    ]
  );
}
