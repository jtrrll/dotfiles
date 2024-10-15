{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins.mini = {
      enable = true;
      modules = {
        icons.enable = true;
        statusline = {};
      };
    };
  };
}
