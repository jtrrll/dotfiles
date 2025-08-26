{
  config,
  lib,
  pkgs,
  ...
}:
let
  backgroundImageExists = builtins.pathExists config.jtrrllDotfiles.theme.backgroundImage;
  schemeDefined = config.jtrrllDotfiles.theme.base16Scheme != null;
in
{
  config = lib.mkIf config.jtrrllDotfiles.theme.enable {
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
          package = pkgs.nerd-fonts.hack;
          name = "Hack Nerd Font Mono";
        };
      };
      image = config.lib.stylix.pixel "base0D";
    }
    // lib.optionalAttrs backgroundImageExists {
      image = builtins.addErrorContext "while fetching background image" (
        builtins.fetchurl { url = "file://${config.jtrrllDotfiles.theme.backgroundImage}"; }
      );
    }
    // lib.optionalAttrs schemeDefined { inherit (config.jtrrllDotfiles.theme) base16Scheme; };
  };
}
