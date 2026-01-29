{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.systemInfo.enable {
    programs = {
      btop = {
        enable = true;
        settings.theme_background = false;
      };
      fastfetch.enable = true;
    };
  };

  options.dotfiles.systemInfo = {
    enable = lib.mkEnableOption "jtrrll's system information configuration";
  };
}
