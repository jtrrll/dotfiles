{ lib' }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.mediaPlayback.enable {
    home.packages = lib'.filterAvailable pkgs.stdenv.hostPlatform.system [ pkgs.vlc ];
  };

  options.dotfiles.mediaPlayback = {
    enable = lib.mkEnableOption "jtrrll's media playback configuration";
  };
}
