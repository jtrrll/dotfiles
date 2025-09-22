{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.nixosConfigurations = builtins.addErrorContext "while defining NixOS configurations" {
    athena = lib.makeOverridable (import ./athena) {
      inherit (inputs.nixos-hardware.nixosModules) lenovo-thinkpad-x1;
      inherit (inputs.nixpkgs.lib) nixosSystem;
      dotfiles = self.nixosModules.default;
    };
  };
}
