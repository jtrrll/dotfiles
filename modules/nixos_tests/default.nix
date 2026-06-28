{
  config,
  lib,
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
  hostTests = builtins.concatLists (
    lib.mapAttrsToList (_: nixos: lib.mapAttrsToList lib.nameValuePair nixos.config.tests) (
      flake.nixosConfigurations or { }
    )
  );
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
      system,
      ...
    }:
    let
      testsFromHosts = lib.listToAttrs hostTests;
    in
    {
      config.nixosTests = testsFromHosts;
      config.checks = lib.mapAttrs' (
        name: drv:
        lib.nameValuePair "nixosModules/${name}" (
          if pkgs.stdenv.isLinux then
            drv
          else
            pkgs.runCommand "nixosModules/${name}" { } ''
              echo "skipped on ${system}" > $out
            ''
        )
      ) config.nixosTests;
    };
}
