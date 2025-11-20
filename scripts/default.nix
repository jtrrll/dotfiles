{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    (inputs.flake-parts.lib.mkTransposedPerSystemModule {
      name = "scripts";
      option = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.package;
        default = { };
        description = "Shell scripts for development";
      };
      file = "./default.nix";
    })
  ];

  perSystem =
    let
      homeConfigurations = builtins.attrNames self.homeConfigurations;
      nixosConfigurations = builtins.attrNames (self.nixosConfigurations or { });
    in
    {
      inputs',
      pkgs,
      self',
      ...
    }:
    {
      apps = builtins.addErrorContext "while defining apps" {
        default = {
          program = self'.scripts.activate;
          type = "app";
        };
      };
      scripts = builtins.addErrorContext "while defining scripts" {
        activate = pkgs.callPackage ./activate {
          inherit homeConfigurations nixosConfigurations;
          rootPath = self;
        };
        lint = pkgs.callPackage ./lint.nix {
          rootPath = self;
          snekcheck = inputs'.snekcheck.packages.default;
        };
        splash = pkgs.callPackage ./splash.nix { };
        update-docs = pkgs.callPackage ./update_docs.nix {
          inherit (self'.packages) options;
        };
      };
    };
}
