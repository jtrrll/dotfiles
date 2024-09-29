{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins.barbar = {
      enable = true;
      settings = {
        auto_hide = 1; # hides the tabline when only one tab is open
      };
    };
  };
}
