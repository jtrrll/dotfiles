{
  pkgs,
  vscode-extensions,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with vscode-extensions.vscode-marketplace; [
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
      ms-vscode.cpptools
      redhat.java
      redhat.vscode-xml
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      shopify.ruby-lsp
      sorbet.sorbet-vscode-extension
      ziglang.vscode-zig
    ];
    package = pkgs.vscodium;
    userSettings = {
      editor = {
        minimap.enabled = false;
        tabSize = 2;
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
}
