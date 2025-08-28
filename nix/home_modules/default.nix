{ inputs, self, ... }:
{
  flake.homeModules = builtins.addErrorContext "while defining home modules" (
    let
      constants = import ./constants.nix;
      lib' = self.lib;
    in
    {
      bat = import ./bat;
      browsers = import ./browsers;
      codeDirectory = import ./code_directory;
      editors = import ./editors {
        inherit (inputs.nixvim.homeModules) nixvim;
        inherit lib';
      };
      fileSystem = import ./file_system;
      gaming = import ./gaming {
        inherit lib';
      };
      git = import ./git;
      homeDirectory = import ./home_directory;
      homeManager = import ./home_manager;
      mediaPlayback = import ./media_playback {
        inherit lib';
      };
      musicLibrary = import ./music_library;
      nix = import ./nix;
      repeat = import ./repeat;
      screenSavers = import ./screensavers;
      systemInfo = import ./system_info;
      terminal = import ./terminal {
        inherit constants;
      };
      theme = import ./theme {
        inherit (inputs.stylix.homeModules) stylix;
      };
    }
  );
}
