{inputs, ...}: {
  flake.dotfiles = {
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
    };

    imports = [
      inputs.nixvim.homeManagerModules.nixvim
      inputs.stylix.homeManagerModules.stylix

      ./editors
      ./file_system
      ./git
      ./nix
      ./screensavers
      ./terminal
      ./theme

      ./bat.nix
      ./btop.nix
      ./fastfetch.nix
      ./home_manager.nix
      ./repeat.nix

      {
        _module.args = {
          constants = import ./constants.nix;
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
