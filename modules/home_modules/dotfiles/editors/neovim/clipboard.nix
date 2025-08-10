{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      clipboard = {
        register = "unnamedplus";
        providers.xclip.enable = true;
      };
      extraConfigLua = ''
        vim.api.nvim_create_autocmd('TextYankPost', {
          callback = function()
            vim.highlight.on_yank()
          end,
          desc = 'Highlight when yanking text',
          group = vim.api.nvim_create_augroup('highlight-yank', { clear = true })
        })
      '';
    };
  };
}
