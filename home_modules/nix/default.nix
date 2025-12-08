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
    nix.settings = lib.mkIf (!pkgs.stdenv.isDarwin) {
      extra-experimental-features = "flakes nix-command no-url-literals";
    };
  };

  options.jtrrllDotfiles.nix = {
    enable = lib.mkEnableOption "jtrrll's Nix configuration";
  };
}
