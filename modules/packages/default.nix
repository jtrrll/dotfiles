{ config, ... }:
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
      packages = lib.mapAttrs (_: addCommonMetadata) (
        config.flake.lib.importFromDirectory {
          importFn = dir: pkgs.callPackage (dir + "/package.nix") { };
        } ./by_name
      );
    in
    {
      config = {
        inherit packages;
        devenv.modules = [ { overlays = [ (_: _: packages) ]; } ];
      };
    };
}
