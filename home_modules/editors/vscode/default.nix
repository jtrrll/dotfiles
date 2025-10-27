{ lib' }:
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.editors.vscode.enable (
    lib.mkMerge [
      {
        fonts.fontconfig.enable = true;
        home.packages = [
          pkgs.nerd-fonts.hack
        ];
        programs.vscode = {
          enable = true;
          # This patch is needed to enable GitHub Copilot Chat in VSCodium.
          # macOS will block this program from running because the patch modifies a signed app bundle.
          # This can be resolved by running it with admin permissions once.
          package = pkgs.vscodium.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
              pkgs.jq
              pkgs.uutils-coreutils-noprefix
            ];
            postInstall =
              (old.postInstall or "")
              + (
                let
                  vscodeProductJSON =
                    if pkgs.stdenv.isDarwin then
                      "Applications/Visual Studio Code.app/Contents/Resources/app/product.json"
                    else
                      "lib/vscode/resources/app/product.json";
                  vscodiumProductJSON =
                    if pkgs.stdenv.isDarwin then
                      "Applications/VSCodium.app/Contents/Resources/app/product.json"
                    else
                      "lib/vscode/resources/app/product.json";
                in
                ''
                  product_file="$out/${vscodiumProductJSON}"

                  if [ -f "$product_file" ]; then
                    printf "Patching product.json to enable GitHub Copilot Chat\n"

                    tmp_file="$product_file.tmp"

                    jq --slurpfile vscode "${pkgs.vscode}/${vscodeProductJSON}" '
                      .defaultChatAgent = $vscode[0]["defaultChatAgent"]
                    ' "$product_file" > "$tmp_file"

                    mv "$tmp_file" "$product_file"
                  else
                    printf "product.json not found at %s\n" "$product_file"
                  fi
                ''
              );
          });
          profiles.default = {
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;
            extensions = builtins.addErrorContext "while evaluating VSCode extensions" (
              lib'.filterAvailable pkgs.stdenv.system (
                (with pkgs.nix-vscode-extensions.open-vsx; [
                  a-h.templ
                  golang.go
                  nvarner.typst-lsp
                  sorbet.sorbet-vscode-extension
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
              )
            );
            globalSnippets = builtins.addErrorContext "while parsing global snippets for VSCode" (
              let
                path = ./snippets/global.json;
                json = if (builtins.pathExists path) then (builtins.fromJSON (builtins.readFile path)) else { };
              in
              assert builtins.isAttrs json;
              json
            );
            languageSnippets = builtins.addErrorContext "while parsing per-language snippets for VSCode" (
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
              )
            );
            userSettings = {
              biome.suggestInstallingGlobally = false;
              editor = {
                cursorSurroundingLines = config.jtrrllDotfiles.editors.linesAroundCursor;
                cursorSurroundingLinesStyle = "all";
                fontFamily = "Hack Nerd Font Mono";
                formatOnSave = false;
                minimap.enabled = false;
                rulers = config.jtrrllDotfiles.editors.lineLengthRulers;
                tabSize = config.jtrrllDotfiles.editors.indentWidth;
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
