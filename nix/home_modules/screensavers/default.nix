{ lib, ... }:
{
  imports = [
    ./bonsai.nix
    ./matrix.nix
  ];

  options.jtrrllDotfiles.screensavers = {
    enable = lib.mkEnableOption "jtrrll's screensavers";
  };
}
