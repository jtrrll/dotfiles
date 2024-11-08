{inputs, ...}: {
  flake.dotfiles = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.dotfiles.enable {
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
      ./services
      ./terminal
      ./theme

      ./bat.nix
      ./bonsai.nix
      ./btop.nix
      ./direnv.nix
      ./fastfetch.nix
      ./file_system.nix
      ./git.nix
      ./home_manager.nix
      ./matrix.nix
      ./repeat.nix

      {
        _module.args = {
          constants = import ./constants.nix;
        };
      }
    ];

    options.dotfiles = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable jtrrll's declarative dotfiles.";
        example = false;
        type = lib.types.bool;
      };
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
