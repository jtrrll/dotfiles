homeManagerModules: {
  config,
  lib,
  pkgs,
  ...
}:
with lib;
  {
    options = {
      dotfiles = {
        enable = mkEnableOption "jtrrll's declarative dotfiles.";
        username = mkOption {
          description = "The name of the user.";
          type = types.str;
        };
        homeDirectory = mkOption {
          description = "The home directory of the user.";
          type = types.path;
        };
      };
    };
    config = mkIf config.dotfiles.enable {
      assertions = [
        {
          assertion = strings.hasInfix config.dotfiles.username config.dotfiles.homeDirectory;
          message = "homeDirectory (${config.dotfiles.homeDirectory}) must contain username (${config.dotfiles.username}).";
        }
      ];

      home = {
        inherit (config.dotfiles) homeDirectory username;
        stateVersion = "23.11";
      };
      programs.home-manager.enable = true;

      dotfiles = {
        programs.enable = true;
        scripts.enable = true;
        theme = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
        };
      };
    };
  }
  // {
    imports =
      homeManagerModules
      ++ [
        ./programs
        ./scripts
        ./theme
        {
          _module.args = {
            args = {inherit (config.dotfiles) homeDirectory username;};
            constants = import ./constants.nix;
          };
        }
      ];
  }
