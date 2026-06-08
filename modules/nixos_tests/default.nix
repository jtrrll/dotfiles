{
  config,
  inputs,
  ...
}:
let
  flakeModule =
    {
      flake-parts-lib,
      lib,
      ...
    }:
    flake-parts-lib.mkTransposedPerSystemModule {
      name = "nixosTests";
      option = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.package;
        default = { };
        description = "NixOS VM integration tests built via pkgs.nixosTest (runNixOSTest)";
      };
      file = ./default.nix;
    };
  inherit (config) flake;
in
{
  imports = [
    { config.flake.modules.flake.nixosTests = flakeModule; }
    flakeModule
  ];

  config.perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      runNixOSTest =
        testModule:
        pkgs.testers.runNixOSTest {
          imports = [ testModule ];
          extraBaseModules.imports = lib.attrValues flake.nixosModules ++ [
            inputs.home-manager.nixosModules.home-manager
          ];
          globalTimeout = lib.mkDefault 300;
        };
      testPkgs = pkgs.extend (_: _: { inherit runNixOSTest; });
    in
    {
      config.nixosTests = flake.lib.importFromDirectory {
        importFn = dir: testPkgs.callPackage (dir + "/test.nix") { };
      } ./by_name;
      config.checks = lib.mkIf pkgs.stdenv.isLinux (
        lib.mapAttrs' (name: lib.nameValuePair "nixosTest-${name}") config.nixosTests
      );
    };
}
