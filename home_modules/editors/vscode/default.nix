{ lib' }:
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.editors.vscode.enable (
    lib.mkMerge [
      {
        fonts.fontconfig.enable = true;
        home.packages = [
          pkgs.nerd-fonts.hack
        ];
        programs.vscode = {
          enable = true;
          package = pkgs.vscodium;
          profiles.default = {
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;
            extensions = lib'.filterAvailable pkgs.stdenv.hostPlatform.system (
              (with pkgs.nix-vscode-extensions.open-vsx; [
                a-h.templ
                golang.go
                nvarner.typst-lsp
                sorbet.sorbet-vscode-extension
                thenuprojectcontributors.vscode-nushell-lang
              ])
              ++ (with pkgs.vscode-extensions; [
                astro-build.astro-vscode
                biomejs.biome
                bradlc.vscode-tailwindcss
                geequlim.godot-tools
                gleam.gleam
                graphql.vscode-graphql
                graphql.vscode-graphql-syntax
                hashicorp.hcl
                hashicorp.terraform
                jnoortheen.nix-ide
                ms-pyright.pyright
                ms-python.python
                ms-toolsai.jupyter
                redhat.java
                redhat.vscode-xml
                redhat.vscode-yaml
                rust-lang.rust-analyzer
                shopify.ruby-lsp
                sumneko.lua
                vscodevim.vim
                ziglang.vscode-zig
              ])
            );
            globalSnippets =
              let
                path = ./snippets/global.json;
                json = if (builtins.pathExists path) then (builtins.fromJSON (builtins.readFile path)) else { };
              in
              assert builtins.isAttrs json;
              json;
            languageSnippets =
              let
                dir = ./snippets/per_language;
                filenames = builtins.attrNames (if (builtins.pathExists dir) then (builtins.readDir dir) else { });
              in
              builtins.listToAttrs (
                builtins.map (
                  filename:
                  assert (lib.hasSuffix ".json" filename);
                  {
                    name = lib.removeSuffix ".json" filename;
                    value =
                      let
                        json = builtins.fromJSON (builtins.readFile "${dir}/${filename}");
                      in
                      assert builtins.isAttrs json;
                      json;
                  }
                ) filenames
              );
            userSettings = {
              biome.suggestInstallingGlobally = false;
              editor = {
                cursorSurroundingLines = config.dotfiles.editors.linesAroundCursor;
                cursorSurroundingLinesStyle = "all";
                fontFamily = "Hack Nerd Font Mono";
                formatOnSave = false;
                minimap.enabled = false;
                rulers = config.dotfiles.editors.lineLengthRulers;
                tabSize = config.dotfiles.editors.indentWidth;
              };
              files = {
                autoSave = "afterDelay";
                enableTrash = false;
                exclude = {
                  "**/.devenv" = true;
                  "**/.direnv" = true;
                  "**/node_modules" = true;
                  "**/*_templ.go" = true;
                };
              };
              nix = {
                enableLanguageServer = true;
                serverPath = "nil";
              };
              redhat.telemetry.enabled = false;
              telemetry = {
                enableCrashReporter = false; # Only relevant for base VSCode, not VSCodium.
                enableTelemetry = false; # Only relevant for base VSCode, not VSCodium.
                feedback.enabled = false;
                telemetryLevel = "off";
              };
              window.zoomLevel = 2;
              workbench = {
                colorTheme = "Default Dark Modern";
                sideBar.location = "right";
              };
            };
          };
        };
      }
      (if options ? stylix then { stylix.targets.vscode.enable = false; } else { })
    ]
  );
}
