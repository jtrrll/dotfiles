{
  inputs,
  self,
  ...
}: {
  flake.homeConfigurations = let
    ### start "impure" ###
    HOME = builtins.getEnv "HOME";
    SYSTEM = builtins.currentSystem;
    USER = builtins.getEnv "USER";
    ### end "impure" ###
    mkConfig = config:
      assert builtins.isAttrs config;
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            self.homeManagerModules.dotfiles
            {
              dotfiles =
                {
                  homeDirectory = HOME;
                  theme.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
                  username = USER;
                }
                // config;
            }
          ];
        };
    pkgs = import inputs.nixpkgs {
      inherit SYSTEM;
      overlays = [self.overlay];
    };
  in {
    ci = mkConfig {theme.enable = false;}; # the theme module is disabled because it doesn't work on headless systems.
    default = mkConfig {};
    work = mkConfig {gaming.enable = false;};
  };
}
