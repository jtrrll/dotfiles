{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs = {
      btop = {
        enable = true;
        settings.theme_background = false;
      };
      fastfetch.enable = true;
    };
  };
}
