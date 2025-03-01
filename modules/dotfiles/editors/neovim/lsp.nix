{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      diagnostics.float.border = "rounded";
      extraConfigLua = ''
        local open_hint_float = function()
          local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
          local diagnostics = vim.diagnostic.get(0, { lnum = cursor_row - 1 })
          local num_diagnostics = #diagnostics

          if num_diagnostics > 0 then
            vim.diagnostic.open_float()
          else
            vim.lsp.buf.hover()
          end
        end

        vim.api.nvim_create_autocmd('CursorHold', {
          callback = open_hint_float,
          desc = 'Open hint float under cursor'
        })

        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })  -- Use the same background as the editor
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })  -- Use the same background as the editor

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
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
          vim.lsp.handlers.hover, { border = border }
        )
      '';
      plugins = {
        lsp = {
          enable = true;
          servers = {
            astro.enable = true;
            bashls.enable = true;
            biome.enable = true;
            clangd.enable = true;
            docker_compose_language_service.enable = true;
            elixirls.enable = true;
            eslint.enable = true;
            gleam.enable = true;
            golangci_lint_ls.enable = true;
            gopls.enable = true;
            hls = {
              enable = true;
              installGhc = true;
            };
            html.enable = true;
            htmx.enable = true;
            java_language_server.enable = true;
            jsonls.enable = true;
            kotlin_language_server.enable = true;
            lemminx.enable = true;
            ltex.enable = true;
            lua_ls.enable = true;
            marksman.enable = true;
            nil_ls.enable = true;
            pyright.enable = true;
            ruby_lsp.enable = true;
            rust_analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
            };
            solargraph.enable = true;
            sqls.enable = true;
            svelte.enable = true;
            texlab.enable = true;
            ts_ls.enable = true;
            yamlls.enable = true;
          };
        };
        lsp-signature = {
          enable = true;
          settings.hint_enable = false;
        };
        lspkind.enable = true;
      };
    };
  };
}
