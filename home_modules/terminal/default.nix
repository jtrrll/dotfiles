{ constants }:
{ lib, ... }:
{
  imports = [
    (import ./multiplexer { inherit constants; })

    ./direnv.nix
    (import ./emulator.nix { inherit constants; })
    ./shell.nix
  ];

  options.jtrrllDotfiles.terminal = {
    enable = lib.mkEnableOption "jtrrll's terminal configuration";
  };
}
