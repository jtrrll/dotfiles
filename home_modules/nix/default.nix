{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.nix.enable {
    nix = {
      gc.automatic = true;
      package = lib.mkDefault pkgs.nix;
      settings = {
        extra-experimental-features = "flakes nix-command no-url-literals";
      };
    };
  };

  options.jtrrllDotfiles.nix = {
    enable = lib.mkEnableOption "jtrrll's Nix configuration";
  };
}
