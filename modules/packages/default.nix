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
        inherit (config.flake) homepage maintainers;
        license = lib.licenses.agpl3Plus;
      };
      importPackagesFromDirectory =
        let
          importFn = filePath: addCommonMetadata (pkgs.callPackage filePath { });
          nameFn = lib.replaceStrings [ "_" ] [ "-" ];
        in
        directory:
        lib.concatMapAttrs (
          name: type:
          let
            path = directory + "/${name}";
          in
          if type == "directory" then
            { "${nameFn name}" = importFn (path + "/package.nix"); }
          else if type == "regular" && lib.hasSuffix ".nix" name then
            { "${nameFn (lib.removeSuffix ".nix" name)}" = importFn path; }
          else
            { }
        ) (builtins.readDir directory);
      packages = importPackagesFromDirectory ./by_name;
    in
    {
      config = {
        inherit packages;
        devenv.modules = [ { overlays = [ (_: _: packages) ]; } ];
      };
    };
}
