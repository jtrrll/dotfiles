{ config, lib, ... }:
{
  options.flake = {
    homepage = lib.mkOption {
      description = "The homepage of this flake";
      type = lib.types.str;
    };
    maintainer = lib.mkOption {
      description = "The maintainer of this flake";
      type = lib.types.attrsOf lib.types.anything;
    };
  };

  config = {
    flake = {
      homepage = "https://github.com/jtrrll/dotfiles";
      lib.checkPackageMetadata =
        checks:
        { meta, name, ... }:
        let
          result = lib.pipe checks [
            (lib.map (check: {
              inherit (check meta) success error;
            }))
            (lib.filter ({ success, ... }: !success))
          ];
        in
        if lib.length result == 0 then
          {
            success = true;
            error = null;
          }
        else
          {
            success = false;
            error = ''
              Package `${name}` failed the following metadata checks:
              ${lib.concatMapStringsSep "\n" ({ error, ... }: "- ${error}") result}
            '';
          };
      maintainer = {
        github = "jtrrll";
        githubId = 77407057;
        name = "Jackson Terrill";
      };
    };
    perSystem =
      let
        inherit (config.flake) homepage;
        inherit (config.flake.lib) checkPackageMetadata;
      in
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        config.checks.packageMetadata =
          let
            checks = [
              (
                meta:
                if meta ? description then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "A description must be set";
                  }
              )
              (
                meta:
                if lib.hasPrefix meta.name (meta.description or "") then
                  {
                    success = false;
                    error = "The description should not repeat the package name";
                  }
                else
                  {
                    success = true;
                    error = null;
                  }
              )
              (
                meta:
                if
                  lib.substring 0 1 (meta.description or "")
                  == lib.toUpper (lib.substring 0 1 (meta.description or ""))
                then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "The first word of the description should be capitalized";
                  }
              )
              (
                meta:
                if lib.hasInfix "\n" (meta.description or "") then
                  {
                    success = false;
                    error = "The description should not contain newlines";
                  }
                else
                  {
                    success = true;
                    error = null;
                  }
              )
              (
                meta:
                if lib.hasSuffix "." (meta.description or "") then
                  {
                    success = false;
                    error = "The description should not end with punctuation";
                  }
                else
                  {
                    success = true;
                    error = null;
                  }
              )
              (
                meta:
                if meta ? homepage then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "A homepage must be set";
                  }
              )
              (
                meta:
                if (meta.homepage or "") == homepage then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "The homepage must be ${homepage}";
                  }
              )
              (
                meta:
                if meta ? license then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "A license must be set";
                  }
              )
              (
                meta:
                if meta.license.free or false then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "The license must be free";
                  }
              )
              (
                meta:
                if meta ? maintainers then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "The maintainers must be set";
                  }
              )
              (
                meta:
                if !(meta ? maintainers) || lib.isList meta.maintainers then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "The maintainers must be a list";
                  }
              )
              (
                meta:
                if !(meta ? maintainers) || (lib.length meta.maintainers) > 0 then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "At least one maintainer must be set";
                  }
              )
              (
                meta:
                if meta ? platforms then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "The supported platforms must be set";
                  }
              )
              (
                meta:
                if !(meta ? platforms) || lib.isList meta.platforms then
                  {
                    success = true;
                    error = null;
                  }
                else
                  {
                    success = false;
                    error = "The supported platforms must be a list";
                  }
              )
            ];

            packages = lib.filterAttrs (name: _: !lib.hasPrefix "devenv" name) config.packages;
            checkFlake = lib.mapAttrsToList (_: checkPackageMetadata checks) packages;
            failedPackages = lib.filter (result: !result.success) checkFlake;
          in
          pkgs.runCommand "check-metadata" { } (
            let
              failedCount = lib.length failedPackages;
            in
            if failedCount > 0 then
              throw "\n${toString failedCount} package(s) failed metadata validation:\n${
                lib.concatMapStringsSep "\n" (result: result.error) failedPackages
              }"
            else
              "echo 'All packages passed metadata validation' > $out"
          );
      };
  };
}
