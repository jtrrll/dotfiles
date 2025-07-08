{inputs, ...}: {
  flake.overlay = builtins.addErrorContext "while defining overlay" (final: prev: let
    unfreePkgs = import inputs.nixpkgs {
      inherit (final) system;
      config.allowUnfree = true;
    };
  in {
    inherit (inputs.snekcheck.packages.${final.system}) snekcheck;
    ghostty =
      if final.stdenv.isDarwin
      then inputs.nur.legacyPackages.${final.system}.repos.DimitarNestorov.ghostty
      else prev.ghostty;
    nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${final.system};
    unfree-vscode-extensions = unfreePkgs.vscode-extensions;
  });
}
