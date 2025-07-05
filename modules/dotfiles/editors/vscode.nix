{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = let
        filterAvailable = pkgsList:
          builtins.filter (pkg: lib.meta.availableOn pkgs.stdenv.system pkg) pkgsList;
      in {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        extensions = builtins.addErrorContext "while evaluating VSCode extensions" (filterAvailable (with pkgs.vscode-extensions; [
          astro-build.astro-vscode
          biomejs.biome
          bradlc.vscode-tailwindcss
          geequlim.godot-tools
          gleam.gleam
          golang.go
          graphql.vscode-graphql
          graphql.vscode-graphql-syntax
          jnoortheen.nix-ide
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
          ziglang.vscode-zig
        ]));
        globalSnippets = builtins.addErrorContext "while parsing global snippets for VSCode" (let
          path = ./snippets/global.json;
          json =
            if (builtins.pathExists path)
            then (builtins.fromJSON (builtins.readFile path))
            else {};
        in
          assert builtins.isAttrs json; json);
        languageSnippets = builtins.addErrorContext "while parsing per-language snippets for VSCode" (let
          dir = ./snippets/per_language;
          filenames = builtins.attrNames (
            if (builtins.pathExists dir)
            then (builtins.readDir dir)
            else {}
          );
        in
          builtins.listToAttrs (builtins.map (filename:
            assert (lib.hasSuffix ".json" filename); {
              name = lib.removeSuffix ".json" filename;
              value = let
                json = builtins.fromJSON (builtins.readFile "${dir}/${filename}");
              in
                assert builtins.isAttrs json; json;
            })
          filenames));
        userSettings = {
          editor = {
            minimap.enabled = false;
            tabSize = config.dotfiles.editors.indentWidth;
            rulers = config.dotfiles.editors.lineLengthRulers;
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
  };
}
