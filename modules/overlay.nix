{inputs, ...}: {
  flake.overlay = final: _: {
    inherit (inputs.snek-check.packages.${final.system}) snek-check;
    vscode-extensions = inputs.nix-vscode-extensions.extensions.${final.system}.vscode-marketplace;
  };
}
