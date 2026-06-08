{
  config,
  inputs,
  lib,
  ...
}:
{
  config.flake.nixosConfigurations =
    let
      hosts = config.flake.lib.importFromDirectory {
        importFn = dir: { imports = [ (inputs.import-tree dir) ]; };
      } ./by_name;
      homeManagerConfig =
        { pkgs, ... }:
        let
          inherit (pkgs.stdenv.hostPlatform) system;
          hmPkgs = inputs.home-manager.inputs.nixpkgs.legacyPackages.${system}.extend (
            _: _: config.flake.packages.${system}
          );
        in
        {
          home-manager = {
            backupFileExtension = "bak";
            sharedModules = lib.attrValues config.flake.homeModules;
            useUserPackages = true;
            extraSpecialArgs = {
              pkgs = hmPkgs;
            };
          };
        };
      nixConfig =
        { lib, ... }:
        {
          nix.settings = {
            extra-experimental-features = [
              "flakes"
              "nix-command"
            ];
            substituters = lib.mkForce [
              "https://cache.nixos.org?priority=1"
              "https://nix-community.cachix.org?priority=2"
              "https://devenv.cachix.org?priority=3"
              "https://install.determinate.systems?priority=4"
            ];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
              "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
            ];
          };
        };
    in
    lib.mapAttrs (
      _: hostConfig:
      inputs.determinate.inputs.nixpkgs.lib.nixosSystem {
        modules = lib.attrValues config.flake.nixosModules ++ [
          hostConfig
          inputs.determinate.nixosModules.default
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
          homeManagerConfig
          nixConfig
          { dotfiles.users.enable = true; }
        ];
        specialArgs = {
          nixosHardwareModules = inputs.nixos-hardware.nixosModules;
        };
      }
    ) hosts;
}
