{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.homeManager.enable {
    news.display = "silent";
    programs.home-manager.enable = true;
  };

  options.jtrrllDotfiles.homeManager = {
    enable = lib.mkEnableOption "jtrrll's home-manager configuration";
  };
}
