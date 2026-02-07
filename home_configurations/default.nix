{
  inputs,
  lib,
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
      mkHomeConfiguration =
        modules:
        assert lib.isList modules && lib.all lib.isAttrs modules;
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            lib.attrValues self.homeModules
            ++ [
              {
                home = {
                  homeDirectory = HOME;
                  username = USER;
                };
              }
              {
                dotfiles.theme.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
              }
            ]
            ++ modules;
        };
      pkgs = import inputs.nixpkgs-home-manager {
        inherit SYSTEM;
        overlays = [ self.overlays.default ];
      };
    in
    {
      default = mkHomeConfiguration [
        {
          dotfiles.presets.full.enable = true;
          home.stateVersion = "23.11";
        }
      ];
      work = mkHomeConfiguration [
        {
          dotfiles = {
            presets.full.enable = true;
            gaming.enable = false;
            musicLibrary.enable = false;
          };
          home.stateVersion = "23.11";
        }
      ];
    };
}
