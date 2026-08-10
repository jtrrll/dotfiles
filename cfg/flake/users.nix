{
  cfg,
  config,
  inputs,
  lib,
  ...
}:
let
  flakeConfig = config;
  sharedModules = (lib.attrValues config.flake.homeModules) ++ [
    inputs.stylix.homeModules.stylix
    inputs.vicinae.homeManagerModules.default
  ];
in
{
  config.flake = {
    users = lib.mapAttrs (_: module: {
      _class = "homeManager";
      imports = sharedModules ++ [ module ];
    }) (cfg.homeManager or { });

    homeConfigurations =
      let
        ### start "impure" ###
        HOME = builtins.getEnv "HOME";
        SYSTEM = builtins.currentSystem;
        USER = builtins.getEnv "USER";
        ### end "impure" ###
      in
      lib.mapAttrs (
        _: user:
        inputs.home-manager.lib.homeManagerConfiguration {
          modules = [
            user
            {
              home = {
                homeDirectory = HOME;
                username = USER;
              };
            }
          ];
          pkgs =
            inputs.home-manager.inputs.nixpkgs.legacyPackages.${SYSTEM}.extend
              config.flake.overlays.default;
        }
      ) config.flake.users;

    modules.nixos.users =
      { config, lib, ... }:
      let
        cfg = config.dotfiles.users;
        users = flakeConfig.flake.users;
      in
      {
        options.dotfiles.users = {
          enable = lib.mkEnableOption "user configurations";
        };

        config = lib.mkIf cfg.enable {
          home-manager.users = users;
          users.users = lib.mapAttrs (_: _: {
            enable = lib.mkDefault false;
            isNormalUser = true;
          }) users;
        };
      };
  };

  config.perSystem =
    { lib, system, ... }:
    {
      homeConfigurationBuildChecks = {
        enable = true;
        extraModules = [
          {
            _module.args.pkgs = lib.mkForce (
              inputs.home-manager.inputs.nixpkgs.legacyPackages.${system}.extend config.flake.overlays.default
            );
          }
        ];
      };
    };
}
