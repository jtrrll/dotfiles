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
          cfg = config.nixosConfigurationBuildChecks;
        in
        {
          options.nixosConfigurationBuildChecks = {
            enable = lib.mkEnableOption "NixOS configuration build checks";
            hosts = lib.mkOption {
              type = lib.types.attrsOf lib.types.raw;
              default = processedFlake.nixosConfigurations;
              description = "The NixOS configurations to check";
            };
          };

          config.checks = lib.mkIf cfg.enable (
            lib.mapAttrs' (
              name: nixos:
              lib.nameValuePair "nixosConfigurations:${name}/build" nixos.config.system.build.toplevel
            ) cfg.hosts
          );
        }
      );
    };
in
{
  imports = [
    { config.flake.modules.flake.nixosConfigurationBuildChecks = flakeModule; }
    flakeModule
  ];

  config.perSystem = {
    nixosConfigurationBuildChecks.enable = true;
  };
}
