{
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
          activatePkg = self.packages.${pkgs.stdenv.hostPlatform.system}.activate.override {
            rootPath = self;
            homeConfigurations = lib.attrNames self.homeConfigurations;
            nixosConfigurations = lib.attrNames self.nixosConfigurations;
          };
        in
        {
          meta.description = activatePkg.meta.description;
          program = activatePkg;
          type = "app";
        };
    };
}
