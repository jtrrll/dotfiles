{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules = {
    homeAssistant = import ./home_assistant { };
    homeManager = import ./home_manager {
      inherit (self) homeModules;
      homeManager = inputs.home-manager.nixosModules.home-manager;
      nixpkgs = inputs.nixpkgs-home-manager;
      overlay = self.overlays.default;
    };
  };
}
