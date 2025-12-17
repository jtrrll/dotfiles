{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.nix.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
    };
  };

  options.jtrrllDotfiles.nix = {
    enable = lib.mkEnableOption "jtrrll's Nix configuration";
  };
}
