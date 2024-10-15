{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins = {
      lsp = {
        enable = true;
        servers = {
          astro.enable = true;
          bashls.enable = true;
          biome.enable = true;
          clangd.enable = true;
          csharp_ls.enable = true;
          docker_compose_language_service.enable = true;
          elixirls.enable = true;
          eslint.enable = true;
          gleam.enable = true;
          golangci_lint_ls.enable = true;
          gopls.enable = true;
          graphql.enable = true;
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
          tailwindcss.enable = true;
          texlab.enable = true;
          ts_ls.enable = true;
          yamlls.enable = true;
          zls.enable = true;
        };
      };
      lsp-lines.enable = true;
      lsp-signature = {
        enable = true;
        settings.hint_enable = false;
      };
      lspkind.enable = true;
    };
  };
}
