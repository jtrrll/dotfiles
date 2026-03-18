{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.devenv.flakeModule ];

  config.perSystem =
    let
      importShellsFromDirectory =
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
            { "${nameFn name}" = import (path + "/shell.nix"); }
          else if type == "regular" && lib.hasSuffix ".nix" name then
            { "${nameFn (lib.removeSuffix ".nix" name)}" = import path; }
          else
            { }
        ) (builtins.readDir directory);
    in
    {
      config.devenv = {
        modules = [
          {
            containers = lib.mkForce { }; # Workaround to remove containers from flake checks.
          }
        ];
        shells = importShellsFromDirectory ./by_name;
      };
    };
}
