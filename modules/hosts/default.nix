{
  inputs,
  lib,
  self,
  ...
}:
{
  config.flake.nixosConfigurations =
    let
      nameFn = lib.replaceStrings [ "_" ] [ "-" ];
      hostsFromDirectory =
        directory:
        lib.concatMapAttrs (
          name: type:
          let
            path = directory + "/${name}";
          in
          if type == "directory" then
            { "${nameFn name}" = "${path}/configuration.nix"; }
          else if type == "regular" && lib.hasSuffix ".nix" name then
            { "${nameFn (lib.removeSuffix ".nix" name)}" = path; }
          else
            { }
        ) (builtins.readDir directory);
      hosts = hostsFromDirectory ./by_name;
    in
    lib.mapAttrs (
      _: path:
      inputs.nixpkgs-nixos.lib.nixosSystem {
        modules = lib.attrValues self.nixosModules ++ [
          path
          {
            _module.args = {
              nixosHardwareModules = inputs.nixos-hardware.nixosModules;
            };
          }
        ];
      }
    ) hosts;
}
