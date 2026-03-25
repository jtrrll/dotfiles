{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    assertions = [
      {
        assertion = lib.strings.hasInfix config.home.username config.home.homeDirectory;
        message = "homeDirectory (${config.home.homeDirectory}) must contain username (${config.home.username}).";
      }
    ];
    home = {
      homeDirectory = lib.mkDefault (
        if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}"
      );
      stateVersion = "23.11";
    };
    xdg.enable = lib.mkDefault true;
  };
}
