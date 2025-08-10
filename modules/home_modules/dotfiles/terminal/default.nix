{ lib, ... }:
{
  imports = [
    ./multiplexer

    ./direnv.nix
    ./emulator.nix
    ./shell.nix
  ];

  options.dotfiles.terminal = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the terminal configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
