{ nixvim }:
{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.mkIf config.dotfiles.editors.neovim.enable (
    lib.mkMerge [
      {
        programs.nixvim = {
          colorschemes.vscode.enable = true;
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
      }
      (if options ? stylix then { stylix.targets.nixvim.enable = false; } else { })
    ]
  );

  imports = [
    nixvim
    ./clipboard.nix
    ./code_tree.nix
    ./completion.nix
    ./files.nix
    ./git.nix
    ./keymaps.nix
    ./lsp.nix
    ./save.nix
    ./status_line.nix
    ./vim_options.nix
  ];
}
