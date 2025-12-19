{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.nix.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
    };
  };

  options.dotfiles.nix = {
    enable = lib.mkEnableOption "jtrrll's Nix configuration";
  };
}
