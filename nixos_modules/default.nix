{ inputs, self, ... }:
{
  flake.nixosModules = builtins.addErrorContext "while defining NixOS modules" {
    dotfiles = {
      home-manager.sharedModules = [ self.homeModules.dotfiles ];
      imports = [ inputs.home-manager.nixosModules.home-manager ];
    };
  };
}
