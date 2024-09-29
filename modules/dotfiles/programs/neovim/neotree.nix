{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins.neo-tree = {
      enable = true;
      window.position = "right";
    };
  };
}
