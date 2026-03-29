{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];

  config.flake =
    let
      usersFromDirectory =
        let
          nameFn = lib.replaceStrings [ "_" ] [ "-" ];
          importFn = dir: { imports = [ (inputs.import-tree dir) ]; };
        in
        dir:
        lib.concatMapAttrs (
          name: type:
          if type == "directory" then
            {
              "${nameFn name}" = importFn "${dir}/${name}";
            }
          else
            { }
        ) (builtins.readDir dir);
      users = usersFromDirectory ./by_name;
    in
    {
      homeConfigurations =
        let
          ### start "impure" ###
          HOME = builtins.getEnv "HOME";
          SYSTEM = builtins.currentSystem;
          USER = builtins.getEnv "USER";
          ### end "impure" ###
        in
        lib.mapAttrs (
          _: userConfig:
          inputs.home-manager.lib.homeManagerConfiguration {
            modules = lib.attrValues self.homeModules ++ [
              userConfig
              {
                home = {
                  homeDirectory = HOME;
                  username = USER;
                };
              }
              inputs.nixvim.homeModules.nixvim
              inputs.stylix.homeModules.stylix
            ];
            pkgs = inputs.home-manager.inputs.nixpkgs.legacyPackages.${SYSTEM}.extend (
              _: _: self.packages.${SYSTEM}
            );
          }
        ) users;

      modules.nixos.homeManagerUsers =
        { lib, ... }:
        {
          imports = [ inputs.home-manager.nixosModules.home-manager ];
          home-manager.users = users;
          users.users = lib.mapAttrs (_: _: {
            enable = lib.mkDefault false;
            isNormalUser = true;
          }) users;
        };
    };
}
