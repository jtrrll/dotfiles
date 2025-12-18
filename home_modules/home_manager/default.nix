{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.homeManager.enable {
    news.display = "silent";
    programs.home-manager.enable = true;
    services.home-manager.autoExpire.enable = true;
  };

  options.dotfiles.homeManager = {
    enable = lib.mkEnableOption "jtrrll's home-manager configuration";
  };
}
