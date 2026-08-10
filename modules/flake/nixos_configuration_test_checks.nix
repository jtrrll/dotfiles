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
      cfg = config.nixosConfigurationTestChecks;
    in
    {
      options.nixosConfigurationTestChecks = {
        enable = lib.mkEnableOption "NixOS configuration test checks";
        hosts = lib.mkOption {
          type = lib.types.attrsOf lib.types.raw;
          default = processedFlake.nixosConfigurations;
          description = "The NixOS configurations whose `config.tests` become checks";
        };
      };

      config.checks = lib.mkIf cfg.enable (
        lib.concatMapAttrs (
          hostName: nixos:
          lib.mapAttrs' (
            testName: test: lib.nameValuePair "nixosConfigurations:${hostName}/tests/${testName}" test
          ) nixos.config.tests
        ) cfg.hosts
      );
    }
  );
}
