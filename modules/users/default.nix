{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];

  config.flake =
    let
      sharedModules = [
        inputs.nixvim.homeModules.nixvim
        inputs.stylix.homeModules.stylix
      ];
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
            modules =
              lib.attrValues config.flake.homeModules
              ++ sharedModules
              ++ [
                userConfig
                {
                  home = {
                    homeDirectory = HOME;
                    username = USER;
                  };
                }
              ];
            pkgs = inputs.home-manager.inputs.nixpkgs.legacyPackages.${SYSTEM}.extend (
              _: _: config.packages.${SYSTEM}
            );
          }
        ) users;

      modules.nixos.homeManagerUsers =
        { lib, ... }:
        {
          imports = [ inputs.home-manager.nixosModules.home-manager ];
          home-manager = {
            inherit sharedModules users;
          };
          users.users = lib.mapAttrs (_: _: {
            enable = lib.mkDefault false;
            isNormalUser = true;
          }) users;
        };
    };
}
