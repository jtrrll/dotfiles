{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.nix.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
    };
    nix = lib.mkIf (!pkgs.stdenv.isDarwin) {
      package = lib.mkDefault pkgs.nix;
      settings.extra-experimental-features = "flakes nix-command no-url-literals";
    };
  };

  options.jtrrllDotfiles.nix = {
    enable = lib.mkEnableOption "jtrrll's Nix configuration";
  };
}
