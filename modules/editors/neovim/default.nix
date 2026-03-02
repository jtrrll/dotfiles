{ nixvim }:
{
  lib,
  options,
  ...
}:
{
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

  config = lib.mkMerge [
    {
      programs.nixvim = {
        colorschemes.vscode.enable = true;
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
    (lib.mkIf (options ? stylix) { stylix.targets.nixvim.enable = false; })
  ];
}
