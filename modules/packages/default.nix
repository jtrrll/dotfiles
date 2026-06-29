{
  config,
  inputs,
  ...
}:
{
  config.perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      addCommonMetadata = lib.addMetaAttrs {
        inherit (config.flake.meta) homepage maintainers;
        license = lib.licenses.agpl3Plus;
      };
      pkgs' = pkgs.extend (
        lib.composeManyExtensions [
          (_: prev: {
            lib = prev.lib.extend inputs.nixvim.lib.overlay;
          })
          (_: _: packages)
        ]
      );

      callPackage = path: args: addCommonMetadata (pkgs'.callPackage path args);
      importPackagesFromDirectory =
        dir:
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair (lib.replaceStrings [ "_" ] [ "-" ] name) (
            callPackage "${dir}/${name}/package.nix" { }
          )
        ) (builtins.readDir dir);
      packages = importPackagesFromDirectory ./by_name;
    in
    {
      config = {
        inherit packages;
        checks =
          lib.mapAttrs' (name: pkg: lib.nameValuePair "packages/${name}/build" pkg) packages
          // lib.concatMapAttrs (
            pkgName: pkg:
            lib.mapAttrs' (testName: test: lib.nameValuePair "packages/${pkgName}/${testName}" test) (
              pkg.passthru.tests or { }
            )
          ) packages;
        devenv.modules = [ { overlays = [ (_: _: packages) ]; } ];
      };
    };
}
