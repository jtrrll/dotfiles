{
  config,
  inputs,
  lib,
  ...
}:
{
  config.flake.nixosConfigurations =
    let
      hostsFromDirectory =
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
      hosts = hostsFromDirectory ./by_name;
    in
    lib.mapAttrs (
      _: hostConfig:
      inputs.nixpkgs-nixos.lib.nixosSystem {
        modules = lib.attrValues config.flake.nixosModules ++ [
          hostConfig
          inputs.determinate.nixosModules.default
        ];
        specialArgs = {
          nixosHardwareModules = inputs.nixos-hardware.nixosModules;
        };
      }
    ) hosts;
}
