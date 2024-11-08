{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.plugins.mini = {
      enable = true;
      modules = {
        icons.enable = true;
        statusline = {};
      };
    };
  };
}
