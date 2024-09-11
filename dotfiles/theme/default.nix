{
  config,
  lib,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./bat.nix
    ./fonts.nix
    ./nixvim.nix
    ./stylix.nix
    ./vscode.nix
    ./zellij.nix
  ];

  options = {
    dotfiles.theme = {
      enable = lib.mkEnableOption "A configurable system-wide theme.";
      backgroundImage = lib.mkOption {
        default = "${config.dotfiles.homeDirectory}/.config/background";
        description = "The file path of the background image to use.";
        type = lib.types.path;
      };
      base16Scheme = lib.mkOption {
        default = null;
        description = ''
          A scheme following the base16 standard.
          If set, this can be a path to a file, a string of YAML, or an attribute set.
          If unset, defaults to a scheme generated from the background image.
        '';
        type = lib.types.nullOr (lib.types.oneOf [lib.types.path lib.types.lines lib.types.attrs]);
      };
      classicCode = lib.mkOption {
        default = true;
        description = ''
          Whether code should be displayed with a VSCode theme instead of the system-wide theme.
        '';
        type = lib.types.bool;
      };
    };
  };
}
