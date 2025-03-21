{inputs, ...}: {
  flake.overlay = final: prev: {
    inherit (inputs.snekcheck.packages.${final.system}) snekcheck;
    ghostty =
      if final.stdenv.isDarwin
      then inputs.nur.legacyPackages.${final.system}.repos.DimitarNestorov.ghostty
      else prev.ghostty;
    vscode-extensions = inputs.nix-vscode-extensions.extensions.${final.system}.vscode-marketplace;
  };
}
