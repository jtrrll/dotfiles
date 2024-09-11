{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.vscode.enable {
    programs.vscode.extensions = with pkgs.vscode-extensions; [
      astro-build.astro-vscode
      biomejs.biome
      bradlc.vscode-tailwindcss
      evzen-wybitul.magic-racket
      geequlim.godot-tools
      gleam.gleam
      golang.go
      graphql.vscode-graphql
      graphql.vscode-graphql-syntax
      jnoortheen.nix-ide
      ms-dotnettools.csharp
      ms-pyright.pyright
      ms-python.python
      ms-toolsai.jupyter
      redhat.java
      redhat.vscode-xml
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      shopify.ruby-lsp
      sorbet.sorbet-vscode-extension
      sumneko.lua
      vscodevim.vim
      xadillax.viml
      ziglang.vscode-zig
    ];
  };
}
