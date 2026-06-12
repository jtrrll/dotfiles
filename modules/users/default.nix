{
  config,
  inputs,
  lib,
  ...
}:
{
  config.flake =
    let
      sharedModules = [
        inputs.stylix.homeModules.stylix
      ];
      importUsersFromDirectory =
        dir:
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair (lib.replaceStrings [ "_" ] [ "-" ] name) {
            imports = [ (inputs.import-tree (dir + "/${name}")) ];
          }
        ) (builtins.readDir dir);
      users = importUsersFromDirectory ./by_name;
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
              _: _: config.flake.packages.${SYSTEM}
            );
          }
        ) users;

      modules.nixos.users =
        { config, lib, ... }:
        let
          cfg = config.dotfiles.users;
        in
        {
          options.dotfiles.users = {
            enable = lib.mkEnableOption "user configurations";
          };

          config = lib.mkIf cfg.enable {
            home-manager = {
              inherit sharedModules users;
            };
            users.users = lib.mapAttrs (_: _: {
              enable = lib.mkDefault false;
              isNormalUser = true;
            }) users;
          };
        };
    };
}
