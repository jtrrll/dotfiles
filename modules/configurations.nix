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
    mkConfig = modules:
      assert (builtins.isList modules) && (builtins.all builtins.isAttrs modules);
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            [
              self.homeManagerModules.dotfiles
              {
                dotfiles = {
                  homeDirectory = HOME;
                  username = USER;
                };
              }
            ]
            ++ modules;
        };
    pkgs = import inputs.nixpkgs {
      inherit SYSTEM;
      overlays = [self.overlay];
    };
  in {
    default = mkConfig [
      {
        dotfiles = {
          theme.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
        };
      }
    ];
    ci = mkConfig [{dotfiles.theme.enable = false;}]; # the theme module is disabled because it doesn't work on headless systems.
  };
}
