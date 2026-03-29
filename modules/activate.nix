{
  config,
  self,
  ...
}:
{
  config.perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      config.apps.default =
        let
          activatePkg = config.flake.packages.${pkgs.stdenv.hostPlatform.system}.activate.override {
            rootPath = self;
            homeConfigurations = lib.attrNames config.flake.homeConfigurations;
            nixosConfigurations = lib.attrNames config.flake.nixosConfigurations;
          };
        in
        {
          meta.description = activatePkg.meta.description;
          program = activatePkg;
          type = "app";
        };
    };
}
