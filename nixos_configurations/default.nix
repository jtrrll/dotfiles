{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs-nixos.lib) nixosSystem;
    in
    {
      ares = lib.makeOverridable (import ./ares) {
        inherit (self.nixosModules) nix;
        inherit nixosSystem;
        dotfiles = self.nixosModules.homeManager;
      };
      athena = lib.makeOverridable (import ./athena) {
        inherit (inputs.nixos-hardware.nixosModules) lenovo-thinkpad-x1;
        inherit (self.nixosModules) nix;
        inherit nixosSystem;
        dotfiles = self.nixosModules.homeManager;
      };
      hestia = lib.makeOverridable (import ./hestia) {
        inherit (inputs.nixos-hardware.nixosModules) raspberry-pi-3;
        inherit (self.nixosModules) homeAssistant;
        inherit (self.nixosModules) nix;
        inherit nixosSystem;
        dotfiles = self.nixosModules.homeManager;
      };
    };
}
