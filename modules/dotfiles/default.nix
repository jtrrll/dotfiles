{
  inputs,
  self,
  ...
}: {
  flake.homeManagerModules.dotfiles = {
    config,
    lib,
    ...
  }: {
    config = {
      assertions = [
        {
          assertion = lib.strings.hasInfix config.dotfiles.username config.dotfiles.homeDirectory;
          message = "homeDirectory (${config.dotfiles.homeDirectory}) must contain username (${config.dotfiles.username}).";
        }
      ];

      home = {
        inherit (config.dotfiles) homeDirectory username;
        stateVersion = "23.11";
      };
      news.display = "silent";
    };

    imports = [
      inputs.nixvim.homeManagerModules.nixvim
      inputs.stylix.homeModules.stylix

      ./editors
      ./file_system
      ./git
      ./nix
      ./screensavers
      ./terminal
      ./theme

      ./bat.nix
      ./browser.nix
      ./gaming.nix
      ./home_manager.nix
      ./media.nix
      ./repeat.nix
      ./system_info.nix

      {
        _module.args = {
          constants = import ./constants.nix;
          lib' = lib // self.lib;
        };
      }
    ];

    options.dotfiles = {
      homeDirectory = lib.mkOption {
        default = "/home/${config.dotfiles.username}";
        description = "The home directory of the user.";
        example = "/home/username";
        type = lib.types.path;
      };
      username = lib.mkOption {
        description = "The name of the user.";
        example = "username";
        type = lib.types.str;
      };
    };
  };
}
