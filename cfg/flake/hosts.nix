{
  cfg,
  config,
  inputs,
  lib,
  ...
}:
{
  config.flake.nixosConfigurations =
    let
      homeManagerConfig = {
        home-manager = {
          backupFileExtension = "bak";
          useGlobalPkgs = true;
          useUserPackages = true;
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
              "https://vicinae.cachix.org?priority=4"
            ];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
              "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
            ];
          };
        };
      sharedModules = builtins.attrValues config.flake.nixosModules ++ [
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        homeManagerConfig
        nixConfig
        { dotfiles.users.enable = true; }
        {
          nixpkgs.overlays = [
            config.flake.overlays.default
          ];
        }
      ];
    in
    lib.mapAttrs (
      _: module:
      inputs.nixpkgs-nixos.lib.nixosSystem {
        modules = sharedModules ++ [ module ];
        specialArgs = {
          nixosHardwareModules = inputs.nixos-hardware.nixosModules;
        };
      }
    ) (cfg.nixos or { });

  config.perSystem = {
    nixosConfigurationBuildChecks.enable = true;
    nixosConfigurationTestChecks.enable = true;
  };
}
