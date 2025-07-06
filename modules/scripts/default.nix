{
  inputs,
  lib,
  ...
}: {
  imports = [
    (inputs.flake-parts.lib.mkTransposedPerSystemModule {
      name = "scripts";
      option = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.package;
        default = {};
        description = "Shell scripts for development";
      };
      file = "./default.nix";
    })

    ./activate.nix
    ./lint.nix
    ./splash.nix
    ./update_docs.nix
  ];
}
