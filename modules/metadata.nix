{
  config.perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config.checks.metadata =
        let
          metadataChecks = {
            description =
              description:
              description != null
              && description != ""
              && lib.substring 0 1 description == lib.toUpper (lib.substring 0 1 description)
              && !lib.hasSuffix "." description;
            license = license: license != null && (license.free or false);
          };
          packages = lib.filterAttrs (name: _: !lib.hasPrefix "devenv" name) config.packages;
          checkPkg =
            pkg: lib.mapAttrs (name: validate: validate (lib.attrByPath [ name ] null pkg.meta)) metadataChecks;

          checkFlake = lib.mapAttrs (_: checkPkg) packages;
          failedPackages = lib.filterAttrs (_: results: lib.any (x: !x) (lib.attrValues results)) checkFlake;
          failingPackagesList = lib.concatStrings (
            lib.mapAttrsToList (
              name: results:
              "  - ${name}:${
                  lib.concatStringsSep "," (lib.mapAttrsToList (k: v: "${k}=${lib.boolToString v}") results)
                }\n"
            ) failedPackages
          );
        in
        pkgs.runCommand "check-metadata"
          {
            failedCount = lib.length (lib.attrNames failedPackages);
            passAsFile = [ "failingPackages" ];
          }
          (
            if lib.length (lib.attrNames failedPackages) > 0 then
              throw "\n${toString config.checks.metadata.failedCount} package(s) failed metadata validation:\n${failingPackagesList}"
            else
              "echo 'All packages passed metadata validation' > $out"
          );
    };
}
