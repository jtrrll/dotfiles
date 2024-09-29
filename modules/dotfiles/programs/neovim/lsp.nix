{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins.lsp = {
      enable = true;
      servers = {
        astro.enable = true;
        bashls.enable = true;
        biome.enable = true;
        clangd.enable = true;
        csharp-ls.enable = true;
        docker-compose-language-service.enable = true;
        elixirls.enable = true;
        eslint.enable = true;
        gdscript.enable = true;
        gleam.enable = true;
        golangci-lint-ls.enable = true;
        gopls.enable = true;
        graphql.enable = true;
        hls.enable = true;
        html.enable = true;
        htmx.enable = true;
        java-language-server.enable = true;
        jsonls.enable = true;
        kotlin-language-server.enable = true;
        lemminx.enable = true;
        ltex.enable = true;
        lua-ls.enable = true;
        marksman.enable = true;
        nil-ls.enable = true;
        purescriptls.enable = true;
        pyright.enable = true;
        ruby-lsp.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        solargraph.enable = true;
        sqls.enable = true;
        svelte.enable = true;
        tailwindcss.enable = true;
        texlab.enable = true;
        ts-ls.enable = true;
        yamlls.enable = true;
        zls.enable = true;
      };
    };
  };
}
