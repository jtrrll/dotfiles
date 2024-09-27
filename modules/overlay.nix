{inputs, ...}: {
  flake.overlay = final: _: {
    vscode-extensions = inputs.nix-vscode-extensions.extensions.${final.system}.vscode-marketplace;
  };
}
