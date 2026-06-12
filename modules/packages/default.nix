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
          inputs.nixvim.overlays.default
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
        devenv.modules = [ { overlays = [ (_: _: packages) ]; } ];
      };
    };
}
