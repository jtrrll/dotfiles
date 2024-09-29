{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins.barbecue = {
      enable = true;
    };
  };
}
