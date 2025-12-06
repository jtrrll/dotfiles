{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.nixosConfigurations = {
    ares = lib.makeOverridable (import ./ares) {
      inherit (inputs.nixpkgs.lib) nixosSystem;
      dotfiles = self.nixosModules.homeManager;
    };
    athena = lib.makeOverridable (import ./athena) {
      inherit (inputs.nixos-hardware.nixosModules) lenovo-thinkpad-x1;
      inherit (inputs.nixpkgs.lib) nixosSystem;
      dotfiles = self.nixosModules.homeManager;
    };
    hestia = lib.makeOverridable (import ./hestia) {
      inherit (inputs.nixos-hardware.nixosModules) raspberry-pi-3;
      inherit (inputs.nixpkgs.lib) nixosSystem;
      dotfiles = self.nixosModules.homeManager;
      inherit (self.nixosModules) homeAssistant;
    };
  };
}
