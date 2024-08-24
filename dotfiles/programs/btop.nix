{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };
  };
}
