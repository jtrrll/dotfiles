{inputs, ...}: {
  flake.overlay = final: _: {
    inherit (inputs.snekcheck.packages.${final.system}) snekcheck;
    vscode-extensions = inputs.nix-vscode-extensions.extensions.${final.system}.vscode-marketplace;
  };
}
