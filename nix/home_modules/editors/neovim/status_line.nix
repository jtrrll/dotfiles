{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.editors.neovim.enable {
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
