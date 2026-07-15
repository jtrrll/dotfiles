{ config, inputs, ... }:
let
  flakeModule =
    {
      config,
      flake-parts-lib,
      ...
    }:
    let
      inherit (config) processedFlake;
    in
    {
      options.perSystem = flake-parts-lib.mkPerSystemOption (
        {
          config,
          lib,
          ...
        }:
        let
          cfg = config.homeConfigurationBuildChecks;
        in
        {
          options.homeConfigurationBuildChecks = {
            enable = lib.mkEnableOption "Home Manager configuration build checks";
            extraModules = lib.mkOption {
              type = lib.types.listOf lib.types.raw;
              default = [ ];
              description = "Extra modules applied to each Home Manager configuration before building it for this system.";
            };
            homeConfigurations = lib.mkOption {
              type = lib.types.attrsOf lib.types.raw;
              default = processedFlake.homeConfigurations;
              description = "The Home Manager configurations to check";
            };
          };

          config.checks = lib.mkIf cfg.enable (
            lib.mapAttrs' (
              name: hm:
              lib.nameValuePair "homeConfigurations:${name}/build" (hm.extendModules { modules = cfg.extraModules; }).activationPackage
            ) cfg.homeConfigurations
          );
        }
      );
    };
in
{
  imports = [
    { config.flake.modules.flake.homeConfigurationBuildChecks = flakeModule; }
    flakeModule
  ];

  config.perSystem =
    { lib, system, ... }:
    {
      homeConfigurationBuildChecks = {
        enable = true;
        extraModules = [
          {
            _module.args.pkgs = lib.mkForce (
              inputs.home-manager.inputs.nixpkgs.legacyPackages.${system}.extend (
                _: _: config.flake.packages.${system} or { }
              )
            );
          }
        ];
      };
    };
}
