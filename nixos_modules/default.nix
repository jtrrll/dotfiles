{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules = builtins.addErrorContext "while defining NixOS modules" {
    homeAssistant = import ./home_assistant { };
    homeManager = import ./home_manager {
      inherit (self) homeModules;
      homeManager = inputs.home-manager.nixosModules.home-manager;
      overlay = self.overlays.default;
    };
  };
}
