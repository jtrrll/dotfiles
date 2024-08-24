{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.nixvim.plugins.mini = {
      enable = true;
      modules = {
        statusline = {};
      };
    };
  };
}
