{
  config,
  inputs,
  lib,
  self,
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
  ];

  perSystem = let
    configurations = builtins.attrNames config.flake.homeConfigurations;
  in
    {
      config,
      pkgs,
      system,
      ...
    }: {
      apps.default = {
        program = config.scripts.activate;
        type = "app";
      };
      scripts = {
        activate = pkgs.callPackage ./activate.nix {
          inherit configurations self;
        };
        lint = pkgs.callPackage ./lint.nix {
          snekcheck = inputs.snekcheck.packages.${system}.default;
        };
        splash = pkgs.callPackage ./splash.nix {};
        update-docs = pkgs.callPackage ./update_docs.nix {
          inherit (config.packages) options;
        };
      };
    };
}
