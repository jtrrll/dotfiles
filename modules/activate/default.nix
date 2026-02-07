{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  perSystem =
    {
      pkgs,
      ...
    }:
    let
      homeConfigurations = lib.attrNames (self.homeConfigurations or { });
      nixosConfigurations = lib.attrNames (self.nixosConfigurations or { });
      activatePkg = pkgs.callPackage (
        {
          gum,
          lib,
          nh,
          replaceVars,
          rootPath,
          writers,
        }:
        let
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
              description = "Activates a home or NixOS configuration.";
            };
          })
      ) { rootPath = self; };
    in
    {
      apps.default = {
        program = activatePkg;
        type = "app";
      };
      packages.activate = activatePkg;
    };
}
