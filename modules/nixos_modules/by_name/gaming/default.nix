{ config, lib, ... }:
let
  cfg = config.dotfiles.gaming;
in
{
  options.dotfiles.gaming = {
    enable = lib.mkEnableOption "jtrrll's gaming configuration";
  };

  config.programs.steam = lib.mkIf cfg.enable {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
