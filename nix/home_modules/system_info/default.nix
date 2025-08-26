{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.systemInfo.enable {
    programs = {
      btop = {
        enable = true;
        settings.theme_background = false;
      };
      fastfetch.enable = true;
    };
  };

  options.jtrrllDotfiles.systemInfo = {
    enable = lib.mkEnableOption "jtrrll's system information configuration";
  };
}
