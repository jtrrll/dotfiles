{ lib, ... }:
{
  imports = [
    ./bonsai.nix
    ./matrix.nix
  ];

  options.dotfiles.screensavers = {
    enable = lib.mkEnableOption "jtrrll's screensavers";
  };
}
