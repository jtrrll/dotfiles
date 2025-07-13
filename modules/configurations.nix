{
  config,
  inputs,
  ...
}: {
  flake.homeConfigurations = let
    ### start "impure" ###
    HOME = builtins.getEnv "HOME";
    SYSTEM = builtins.currentSystem;
    USER = builtins.getEnv "USER";
    ### end "impure" ###
    mkConfig = cfg:
      assert builtins.isAttrs cfg;
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            config.flake.homeModules.dotfiles
            {
              dotfiles =
                {
                  homeDirectory = HOME;
                  theme.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
                  username = USER;
                }
                // cfg;
            }
          ];
        };
    pkgs = import inputs.nixpkgs {
      inherit SYSTEM;
      overlays = [config.flake.overlays.default];
    };
  in {
    default = mkConfig {};
    headless = mkConfig {
      browser.enable = false;
      gaming.enable = false;
      screensavers.enable = false;
      theme.enable = false;
    };
    work = mkConfig {gaming.enable = false;};
  };
}
