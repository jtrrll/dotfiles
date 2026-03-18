{
  inputs,
  lib,
  self,
  ...
}:
{
  config.flake.nixosConfigurations =
    let
      importConfiguration =
        filePath:
        lib.makeOverridable (import filePath) {
          inherit (inputs.nixpkgs-nixos.lib) nixosSystem;
          nixosModules = lib.attrValues self.nixosModules;
          nixosHardwareModules = inputs.nixos-hardware.nixosModules;
        };
      importNixosConfigurationsFromDirectory =
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
    importNixosConfigurationsFromDirectory ./by_name;
}
