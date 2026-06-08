{
  config,
  inputs,
  lib,
  ...
}:
{
  config.flake = {
    nixosModules =
      lib.mapAttrs
        (_: module: {
          imports = [ module ];
          meta = {
            inherit (config.flake.meta) maintainers;
          };
        })
        (
          config.flake.modules.nixos
          // (config.flake.lib.importFromDirectory {
            importFn = dir: { imports = [ (inputs.import-tree dir) ]; };
          } ./by_name)
        );
  };
}
