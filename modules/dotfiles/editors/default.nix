{lib, ...}: {
  imports = [
    ./neovim

    ./vscode.nix
  ];

  options.dotfiles.editors = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the editor configurations.";
      example = false;
      type = lib.types.bool;
    };
    indentWidth = lib.mkOption {
      default = 2;
      description = "The number of spaces per indent.";
      example = 4;
      type = lib.types.int;
    };
    lineLengthRulers = lib.mkOption {
      default = [100 120];
      description = "The columns to place vertical lines on.";
      example = [80];
      type = lib.types.listOf lib.types.int;
    };
  };
}
