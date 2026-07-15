_:
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
          system,
          ...
        }:
        let
          cfg = config.packagePassthruTestsChecks;
        in
        {
          options.packagePassthruTestsChecks = {
            enable = lib.mkEnableOption "package passthru.tests checks";
            packages = lib.mkOption {
              type = lib.types.attrsOf lib.types.package;
              default = processedFlake.packages.${system};
              description = "The set of packages whose passthru.tests to expose as checks";
            };
          };

          config.checks = lib.mkIf cfg.enable (
            lib.concatMapAttrs (
              packageName: package:
              lib.mapAttrs' (testName: test: lib.nameValuePair "packages:${packageName}/tests/${testName}" test) (
                package.passthru.tests or { }
              )
            ) cfg.packages
          );
        }
      );
    };
in
{
  imports = [
    { config.flake.modules.flake.packagePassthruTestsChecks = flakeModule; }
    flakeModule
  ];

  config.perSystem = {
    packagePassthruTestsChecks.enable = true;
  };
}
