{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batgrep batman];
    };
  };
}
