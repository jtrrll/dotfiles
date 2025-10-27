{ inputs, ... }:
{
  flake.overlays = builtins.addErrorContext "while defining overlays" {
    default = final: prev: {
      ghostty = if final.stdenv.isDarwin then prev.ghostty-bin else prev.ghostty;
      nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${final.system};
      snekcheck = inputs.snekcheck.packages.${final.system}.default;
    };
  };
}
