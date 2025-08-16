{ inputs, ... }:
{
  flake.overlays.default = builtins.addErrorContext "while defining overlay" (
    final: prev:
    let
      unfreePkgs = import inputs.nixpkgs {
        inherit (final) system;
        config.allowUnfree = true;
      };
    in
    {
      inherit (unfreePkgs) vscode;
      ghostty =
        if final.stdenv.isDarwin then
          prev.ghostty-bin
        else
          prev.ghostty;
      nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${final.system};
      snekcheck = inputs.snekcheck.packages.${final.system}.default;
      unfree-vscode-extensions = unfreePkgs.vscode-extensions;
    }
  );
}
