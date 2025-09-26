{ inputs, self, ... }:
{
  flake.nixosModules = builtins.addErrorContext "while defining NixOS modules" {
    default = {
      home-manager.sharedModules = [ self.homeModules.default ];
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      nixpkgs.overlays = [ self.overlays.default ];
    };
  };
}
