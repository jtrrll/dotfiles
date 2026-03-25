{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.theme;
  backgroundImageExists = builtins.pathExists cfg.backgroundImage;
  schemeDefined = cfg.base16Scheme != null;
in
{
  options.dotfiles.theme = {
    enable = lib.mkEnableOption "jtrrll's system-wide theme";
    backgroundImage = lib.mkOption {
      default = "${config.home.homeDirectory}/.config/background";
      defaultText = lib.literalExpression "~/.config/background";
      description = "The file path of the background image to use.";
      example = "path/to/background.png";
      type = lib.types.path;
    };
    base16Scheme = lib.mkOption {
      default = null;
      description = ''
        A scheme following the base16 standard.
        If set, this can be a path to a file, a string of YAML, or an attribute set.
        If unset, defaults to a scheme generated from the background image.
      '';
      example = "path/to/gruvbox-material-dark-medium.yaml";
      type = lib.types.nullOr (
        lib.types.oneOf [
          lib.types.path
          lib.types.lines
          lib.types.attrs
        ]
      );
    };
  };

  config = lib.mkIf cfg.enable (
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
        stylix.image = builtins.fetchurl { url = "file://${cfg.backgroundImage}"; };
      })
      (lib.mkIf schemeDefined {
        stylix = {
          inherit (cfg) base16Scheme;
        };
      })
    ]
  );
}
