_:
{
  config = {
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
