{
  config,
  lib,
  ...
}:
with lib; {
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
      enable = mkEnableOption "A configurable system-wide theme.";
      backgroundImage = mkOption {
        default = "${config.dotfiles.homeDirectory}/.config/background";
        description = "The file path of the background image to use.";
        type = types.path;
      };
      base16Scheme = mkOption {
        default = null;
        description = ''
          A scheme following the base16 standard.
          If set, this can be a path to a file, a string of YAML, or an attribute set.
          If unset, defaults to a scheme generated from the background image.
        '';
        type = types.nullOr (types.oneOf [types.path types.lines types.attrs]);
      };
      classicCode = mkOption {
        default = true;
        description = ''
          Whether code should be displayed with a VSCode theme instead of the system-wide theme.
        '';
        type = types.bool;
      };
    };
  };
}
