{ lib' }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.mediaPlayback.enable {
    home.packages = lib'.filterAvailable pkgs.stdenv.system [ pkgs.vlc ];
  };

  options.jtrrllDotfiles.mediaPlayback = {
    enable = lib.mkEnableOption "jtrrll's media playback configuration";
  };
}
