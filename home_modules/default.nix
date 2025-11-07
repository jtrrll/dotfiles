{ inputs, self, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];
  flake.homeModules = builtins.addErrorContext "while defining Home Manager modules" {
    default = {
      imports =
        let
          constants = import ./constants.nix;
          lib' = self.lib;
        in
        [
          ./ai
          ./bat
          ./browsers
          ./code_directory
          (import ./editors {
            inherit (inputs.nixvim.homeModules) nixvim;
            inherit lib';
          })
          ./file_system
          (import ./gaming { inherit lib'; })
          ./git
          ./home_directory
          ./home_manager
          (import ./media_playback { inherit lib'; })
          ./music_library
          ./nix
          ./repeat
          ./screensavers
          ./system_info
          (import ./terminal { inherit constants; })
          (import ./theme { inherit (inputs.stylix.homeModules) stylix; })
        ];
    };
    retroarch = import ./retroarch;
  };
}
