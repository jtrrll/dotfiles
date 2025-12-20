{
  inputs,
  self,
  ...
}:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];
  flake.homeConfigurations =
    let
      ### start "impure" ###
      HOME = builtins.getEnv "HOME";
      SYSTEM = builtins.currentSystem;
      USER = builtins.getEnv "USER";
      ### end "impure" ###
      mkConfig =
        cfg:
        assert builtins.isAttrs cfg;
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = builtins.attrValues self.homeModules ++ [
            {
              home = {
                homeDirectory = HOME;
                stateVersion = "23.11";
                username = USER;
              };
            }
            cfg
          ];
        };
      pkgs = import inputs.nixpkgs-home-manager {
        inherit SYSTEM;
        overlays = [ self.overlays.default ];
      };
    in
    {
      default = mkConfig {
        dotfiles.presets.full.enable = true;
      };
      work = mkConfig {
        dotfiles = {
          presets.full.enable = true;
          gaming.enable = false;
          musicLibrary.enable = false;
        };
      };
    };
}
