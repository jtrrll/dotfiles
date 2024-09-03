{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf (config.dotfiles.programs.enable && elem "neovim" config.dotfiles.programs.editors) {
    programs.nixvim.plugins.indent-blankline = {
      enable = true;
      settings = {
        scope.enabled = true;
      };
    };
  };
}
