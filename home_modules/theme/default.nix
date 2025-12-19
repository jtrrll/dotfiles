{ stylix }:
{
  config,
  lib,
  ...
}:
{
  imports = [
    stylix
    ./fonts.nix
    ./stylix.nix
  ];

  options.dotfiles.theme = {
    enable = lib.mkEnableOption "jtrrll's system-wide theme";
    backgroundImage = lib.mkOption {
      default = "${config.home.homeDirectory}/.config/background";
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
}
