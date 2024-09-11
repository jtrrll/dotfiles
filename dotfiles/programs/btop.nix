{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.btop.enable {
    programs.btop = {
      enable = true;
      settings.theme_background = false;
    };
  };

  options = {
    dotfiles.programs.btop = {
      enable = lib.mkEnableOption "btop";
    };
  };
}
