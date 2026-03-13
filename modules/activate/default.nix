{
  inputs,
  self,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.perSystem =
    {
      pkgs,
      ...
    }:
    {
      config = {
        apps.default =
          let
            activatePkg = self.packages.${pkgs.stdenv.hostPlatform.system}.activate;
          in
          {
            meta.description = activatePkg.meta.description;
            program = activatePkg;
            type = "app";
          };
        packages.activate = pkgs.callPackage (
          {
            gum,
            lib,
            nh,
            replaceVars,
            rootPath,
            writers,
          }:
          let
            homeConfigurations = lib.attrNames (self.homeConfigurations or { });
            nixosConfigurations = lib.attrNames (self.nixosConfigurations or { });

            homeConfigurationsString =
              assert lib.isList homeConfigurations && lib.all lib.isString homeConfigurations;
              lib.concatStringsSep "\n" homeConfigurations;

            nixosConfigurationsString =
              assert lib.isList nixosConfigurations && lib.all lib.isString nixosConfigurations;
              lib.concatStringsSep "\n" nixosConfigurations;

            script = replaceVars ./activate.nu {
              HOME_CONFIGURATIONS = homeConfigurationsString;
              NIXOS_CONFIGURATIONS = nixosConfigurationsString;
            };
          in
          (writers.writeNuBin "activate" {
            makeWrapperArgs = [
              "--prefix"
              "PATH"
              ":"
              (lib.makeBinPath [
                gum
                nh
              ])
              "--set"
              "NH_FLAKE"
              "${rootPath}"
            ];
          } (lib.readFile script)).overrideAttrs
            (oldAttrs: {
              meta = (oldAttrs.meta or { }) // {
                description = "Activates a home or NixOS configuration";
                license = lib.licenses.mit;
              };
            })
        ) { rootPath = self; };
      };
    };
}
