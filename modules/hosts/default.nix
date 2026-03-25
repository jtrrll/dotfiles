{
  inputs,
  lib,
  self,
  ...
}:
{
  config.flake.nixosConfigurations =
    let
      hostsFromDirectory =
        dir:
        lib.concatMapAttrs (
          name: type:
          if type == "directory" then
            {
              "${lib.replaceStrings [ "_" ] [ "-" ] name}" = {
                imports = [ (inputs.import-tree dir) ];
              };
            }
          else
            { }
        ) (builtins.readDir dir);
      hosts = hostsFromDirectory ./by_name;
    in
    lib.mapAttrs (
      _: hostConfig:
      inputs.nixpkgs-nixos.lib.nixosSystem {
        specialArgs = {
          nixosHardwareModules = inputs.nixos-hardware.nixosModules;
        };
        modules = lib.attrValues self.nixosModules ++ [
          hostConfig
        ];
      }
    ) hosts;
}
