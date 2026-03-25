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
                imports = [ (inputs.import-tree "${dir}/${name}") ];
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
        modules = lib.attrValues self.nixosModules ++ [
          hostConfig
          {
            _module.args = {
              nixosHardwareModules = inputs.nixos-hardware.nixosModules;
            };
          }
        ];
      }
    ) hosts;
}
