{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      defaultEditor = true;
      enable = true;
      plugins.lz-n.enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins.snacks = {
        enable = true;
        settings = {
          bigfile.enabled = true;
          quickfile.enabled = true;
        };
      };
    };
  };

  imports = [
    ./clipboard.nix
    ./code_tree.nix
    ./completion.nix
    ./dashboard.nix
    ./files.nix
    ./git.nix
    ./keymaps.nix
    ./lsp.nix
    ./save.nix
    ./status_line.nix
    ./tabs.nix
    ./vim_options.nix
  ];
}
