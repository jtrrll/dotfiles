{
  config,
  inputs,
  lib,
  ...
}:
{
  config.flake.nixosConfigurations =
    let
      importHostsFromDirectory =
        dir:
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair (lib.replaceStrings [ "_" ] [ "-" ] name) {
            imports = [ (inputs.import-tree (dir + "/${name}")) ];
          }
        ) (builtins.readDir dir);
      hosts = importHostsFromDirectory ./by_name;
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
              "https://vicinae.cachix.org?priority=5"
            ];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
              "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
              "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
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
          inputs.sops-nix.nixosModules.sops
          homeManagerConfig
          nixConfig
          { dotfiles.users.enable = true; }
          {
            nixpkgs.overlays = [
              (_: prev: config.flake.packages.${prev.stdenv.hostPlatform.system} or { })
            ];
          }
        ];
        specialArgs = {
          nixosHardwareModules = inputs.nixos-hardware.nixosModules;
        };
      }
    ) hosts;

  config.perSystem =
    { lib, ... }:
    {
      checks = lib.concatMapAttrs (
        hostName: nixos:
        lib.mapAttrs' (
          testName: test: lib.nameValuePair "nixosConfigurations:${hostName}/tests/${testName}" test
        ) nixos.config.tests
      ) config.flake.nixosConfigurations;
    };
}
