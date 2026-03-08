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
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            lib.attrValues self.homeModules
            ++ [
              {
                home = {
                  homeDirectory = HOME;
                  stateVersion = "23.11";
                  username = USER;
                };
              }
            ]
            ++ modules;
        };
      pkgs = inputs.nixpkgs-home-manager.legacyPackages.${SYSTEM};
    in
    {
      default = mkHomeConfiguration [ ];
    };
}
