{
  config,
  inputs,
  lib,
  ...
}:
let
  mergeWithoutCollisions = builtins.foldl' lib.attrsets.unionOfDisjoint { };
  importModulesFromDirectory =
    dir:
    lib.mapAttrs' (
      name: _:
      lib.nameValuePair (lib.replaceStrings [ "_" ] [ "-" ] name) {
        imports = [ (inputs.import-tree (dir + "/${name}")) ];
      }
    ) (builtins.readDir dir);
in
{
  config.flake = {
    homeModules =
      lib.mapAttrs
        (_: module: {
          imports = [ module ];
          meta = {
            inherit (config.flake.meta) maintainers;
          };
        })
        (mergeWithoutCollisions [
          config.flake.modules.homeManager
          (importModulesFromDirectory ./by_name)
        ]);
  };
}
