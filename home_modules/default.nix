{ inputs, self, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];
  flake.homeModules = {
    default =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.dotfiles.presets;
      in
      {
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

        options.dotfiles.presets = {
          minimal.enable = lib.mkEnableOption "jtrrll's minimal dotfiles";
          full.enable = lib.mkEnableOption "jtrrll's full dotfiles";
        };

        config.dotfiles = lib.mkMerge [
          (lib.mkIf cfg.minimal.enable {
            bat.enable = lib.mkDefault true;
            editors.neovim.enable = lib.mkDefault true;
            fileSystem.enable = lib.mkDefault true;
            git.enable = lib.mkDefault true;
            homeManager.enable = lib.mkDefault true;
            nix.enable = lib.mkDefault true;
            systemInfo.enable = lib.mkDefault true;
            terminal.enable = lib.mkDefault true;
          })
          (lib.mkIf cfg.full.enable {
            ai.enable = lib.mkDefault true;
            bat.enable = lib.mkDefault true;
            browsers.brave.enable = lib.mkDefault true;
            codeDirectory.enable = lib.mkDefault true;
            editors = {
              neovim.enable = lib.mkDefault true;
              zed.enable = lib.mkDefault true;
            };
            fileSystem.enable = lib.mkDefault true;
            gaming.enable = lib.mkDefault true;
            git.enable = lib.mkDefault true;
            homeManager.enable = lib.mkDefault true;
            mediaPlayback.enable = lib.mkDefault true;
            musicLibrary.enable = lib.mkDefault true;
            nix.enable = lib.mkDefault true;
            repeat.enable = lib.mkDefault true;
            screensavers.enable = lib.mkDefault true;
            systemInfo.enable = lib.mkDefault true;
            terminal.enable = lib.mkDefault true;
            theme = {
              base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
              enable = lib.mkDefault true;
            };
          })
        ];
      };
  };
}
