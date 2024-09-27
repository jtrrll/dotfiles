{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins.indent-blankline = {
      enable = true;
      settings = {
        scope.enabled = true;
      };
    };
  };
}
