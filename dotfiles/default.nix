homeManagerModules: {
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

  imports =
    homeManagerModules
    ++ [
      ./programs
      ./scripts
      ./theme
      {
        _module.args = {
          constants = import ./constants.nix;
        };
      }
    ];

  options = {
    dotfiles = {
      enable = lib.mkEnableOption "jtrrll's declarative dotfiles.";
      homeDirectory = lib.mkOption {
        default = "/home/${config.dotfiles.username}";
        description = "The home directory of the user.";
        type = lib.types.path;
      };
      username = lib.mkOption {
        description = "The name of the user.";
        type = lib.types.str;
      };
    };
  };
}
