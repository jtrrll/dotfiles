{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.nixosConfigurations = builtins.addErrorContext "while defining NixOS configurations" {
    ares = lib.makeOverridable (import ./ares) {
      inherit (inputs.nixpkgs.lib) nixosSystem;
      dotfiles = self.nixosModules.default;
    };
    athena = lib.makeOverridable (import ./athena) {
      inherit (inputs.nixos-hardware.nixosModules) lenovo-thinkpad-x1;
      inherit (inputs.nixpkgs.lib) nixosSystem;
      dotfiles = self.nixosModules.default;
    };
    hestia = lib.makeOverridable (import ./hestia) {
      inherit (inputs.nixos-hardware.nixosModules) raspberry-pi-3;
      inherit (inputs.nixpkgs.lib) nixosSystem;
      dotfiles = self.nixosModules.default;
    };
  };
}
