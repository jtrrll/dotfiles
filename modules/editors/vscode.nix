{
  pkgs,
  vscode-extensions,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with vscode-extensions.vscode-marketplace; [
      geequlim.godot-tools
      golang.go
      jnoortheen.nix-ide
      ms-pyright.pyright
      ms-python.python
      ms-toolsai.jupyter
      shopify.ruby-lsp
      sorbet.sorbet-vscode-extension
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
      window.zoomLevel = 2;
      workbench.sideBar.location = "right";
    };
  };
}
