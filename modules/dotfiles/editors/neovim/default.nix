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
    };
  };

  imports = [
    ./clipboard.nix
    ./code_tree.nix
    ./completion.nix
    ./files.nix
    ./git.nix
    ./keymaps.nix
    ./lsp.nix
    ./misc_lua.nix
    ./save.nix
    ./status_line.nix
    ./vim_options.nix
    ./welcome.nix
  ];
}
