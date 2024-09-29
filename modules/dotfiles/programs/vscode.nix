{
  config,
  constants,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.vscode.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
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
      package = pkgs.vscodium;
      userSettings = {
        editor = {
          minimap.enabled = false;
          tabSize = constants.INDENT_WIDTH;
          rulers = [constants.LINE_LENGTH.WARNING constants.LINE_LENGTH.MAX];
        };
        nix = {
          enableLanguageServer = true;
          serverPath = "nil";
        };
        redhat.telemetry.enabled = false;
        window.zoomLevel = 2;
        workbench.sideBar.location = "right";
      };
    };
  };

  options = {
    dotfiles.programs.vscode = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable VSCode.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
