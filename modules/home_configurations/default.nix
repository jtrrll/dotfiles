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
      importConfiguration =
        filePath:
        inputs.home-manager.lib.homeManagerConfiguration {
          modules = lib.attrValues self.homeModules ++ [
            {
              home = {
                homeDirectory = HOME;
                stateVersion = "23.11";
                username = USER;
              };
            }
            (import filePath)
          ];
          pkgs = inputs.home-manager.inputs.nixpkgs.legacyPackages.${SYSTEM};
        };
      importHomeConfigurationsFromDirectory =
        let
          nameFn = lib.replaceStrings [ "_" ] [ "-" ];
        in
        directory:
        lib.concatMapAttrs (
          name: type:
          let
            path = directory + "/${name}";
          in
          if type == "directory" then
            { "${nameFn name}" = importConfiguration (path + "/configuration.nix"); }
          else if type == "regular" && lib.hasSuffix ".nix" name then
            { "${nameFn (lib.removeSuffix ".nix" name)}" = importConfiguration path; }
          else
            { }
        ) (builtins.readDir directory);
    in
    importHomeConfigurationsFromDirectory ./by_name;
}
