{
  config,
  lib,
  ...
}: {
  imports = [
    ./bat.nix
    ./fish.nix
    ./fonts.nix
    ./ghostty.nix
    ./nixvim.nix
    ./stylix.nix
    ./vscode.nix
    ./zellij.nix
  ];

  options.dotfiles.theme = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable a configurable system-wide theme.";
      example = false;
      type = lib.types.bool;
    };
    backgroundImage = lib.mkOption {
      default = "${config.dotfiles.homeDirectory}/.config/background";
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
      type = lib.types.nullOr (lib.types.oneOf [lib.types.path lib.types.lines lib.types.attrs]);
    };
  };
}
