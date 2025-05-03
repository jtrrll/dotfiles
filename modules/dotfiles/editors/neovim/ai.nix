{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      extraConfigLua = ''
        vim.api.nvim_create_autocmd("BufWinEnter", {
          callback = function()
            if vim.api.nvim_win_get_config(0).relative ~= "" then
              vim.wo.colorcolumn = ""
              vim.wo.cursorline = false
            end
          end,
          desc = 'Hide rulers in CodeCompanion chat window',
        })
      '';
      plugins = {
        codecompanion.enable = true;
        copilot-lua = {
          enable = true;
          settings = {
            panel = {
              enabled = false;
              layout.position = "right";
            };
            suggestion.enabled = false;
          };
        };
      };
    };
  };
}
