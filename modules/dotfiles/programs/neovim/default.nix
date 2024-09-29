{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim = {
      defaultEditor = true;
      enable = true;
      extraConfigLua = ''
        -- UI
        -- Define a border style
        local border = {
          {"╭", "FloatBorder"},
          {"─", "FloatBorder"},
          {"╮", "FloatBorder"},
          {"│", "FloatBorder"},
          {"╯", "FloatBorder"},
          {"─", "FloatBorder"},
          {"╰", "FloatBorder"},
          {"│", "FloatBorder"},
        }

        -- Customize the LSP hover handler
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })  -- Use the same background as the editor
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })  -- Use the same background as the editor
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
          vim.lsp.handlers.hover, {
            border = border
          }
        )

        vim.api.nvim_create_autocmd('TextYankPost', {
          desc = 'Highlight when yanking text',
          group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
          callback = function()
            vim.highlight.on_yank()
          end
        })
      '';
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };

  imports = [
    ./alpha.nix
    ./autopairs.nix
    ./autosave.nix
    ./barbar.nix
    ./barbecue.nix
    ./cmp.nix
    ./gitsigns.nix
    ./keymaps.nix
    ./lsp.nix
    ./mini.nix
    ./neotree.nix
    ./opts.nix
    ./treesitter.nix
  ];

  options = {
    dotfiles.programs.neovim = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable Neovim.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
