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
          activatePkg = config.packages.${pkgs.stdenv.hostPlatform.system}.activate.override {
            rootPath = self;
            homeConfigurations = lib.attrNames config.homeConfigurations;
            nixosConfigurations = lib.attrNames config.nixosConfigurations;
          };
        in
        {
          meta.description = activatePkg.meta.description;
          program = activatePkg;
          type = "app";
        };
    };
}
