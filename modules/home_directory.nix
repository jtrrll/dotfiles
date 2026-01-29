{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.homeDirectory =
    {
      config,
      lib,
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
        home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
        xdg.enable = true;
      };
    };
}
