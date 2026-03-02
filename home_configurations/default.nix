{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  config.flake.homeConfigurations =
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
                  sessionVariables = {
                    EDITOR = "nvim";
                    VISUAL = "zeditor";
                  };
                };
              }
            ]
            ++ modules;
        };
      pkgs = import inputs.nixpkgs-home-manager {
        inherit SYSTEM;
      };
    in
    {
      work = mkHomeConfiguration [
        {
          dotfiles = {
            ai.enable = false;
            theme = {
              base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
              enable = true;
            };
          };
          home.stateVersion = "23.11";
          programs = {
            prismlauncher.enable = false;
            vesktop.enable = false;
          };
          services.musicLibrary.enable = false;
        }
      ];
    };
}
