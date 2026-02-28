{
  inputs,
  lib,
  self,
  ...
}:
{
  config.flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs-nixos.lib) nixosSystem;
    in
    {
      ares = lib.makeOverridable (import ./ares) {
        inherit nixosSystem;
        nixosModules = lib.attrValues self.nixosModules;
      };
      athena = lib.makeOverridable (import ./athena) {
        inherit (inputs.nixos-hardware.nixosModules) lenovo-thinkpad-x1;
        inherit nixosSystem;
        nixosModules = lib.attrValues self.nixosModules;
      };
      hestia = lib.makeOverridable (import ./hestia) {
        inherit (inputs.nixos-hardware.nixosModules) raspberry-pi-3;
        inherit nixosSystem;
        nixosModules = lib.attrValues self.nixosModules;
      };
    };
}
