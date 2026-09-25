{ lib, pkgs, ... }:
{
  plugins.lazy.plugins = lib.mkAfter [
    {
      pkg = pkgs.vimPlugins.vscode-nvim;
      name = "vscode.nvim";
      lazy = false;
      priority = 11000;
    }
    {
      __unkeyed = "LazyVim/LazyVim";
      opts.colorscheme = "vscode";
    }
    {
      __unkeyed = "folke/tokyonight.nvim";
      enabled = false;
    }
    {
      __unkeyed = "catppuccin/nvim";
      name = "catppuccin";
      enabled = false;
    }
  ];
}
