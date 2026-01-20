{ constants }:
{ lib, ... }:
{
  imports = [
    ./direnv.nix
    (import ./emulator.nix { inherit constants; })
    (import ./multiplexer.nix { inherit constants; })
    ./shell.nix
  ];

  options.dotfiles.terminal = {
    enable = lib.mkEnableOption "jtrrll's terminal configuration";
  };
}
