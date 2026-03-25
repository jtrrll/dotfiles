{
  lib,
  ...
}:
{
  config = {
    news.display = "silent";
    programs.home-manager.enable = lib.mkDefault true;
    services.home-manager.autoExpire.enable = lib.mkDefault true;
  };
}
