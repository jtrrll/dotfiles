{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        icons.enable = true;
        statusline = { };
      };
    };
  };
}
