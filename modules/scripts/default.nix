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
    ./generate_docs.nix
    ./lint.nix
    ./splash.nix
  ];
}
