{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.windowManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.dotfiles.windowManager;
    in
    {
      options.dotfiles.windowManager = {
        enable = lib.mkEnableOption "jtrrll's window manager configuration" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          (lib.mkIf pkgs.stdenv.isDarwin {
            programs.aerospace = {
              enable = true;
              launchd.enable = true;
              settings = {
                gaps = {
                  inner = {
                    horizontal = 8;
                    vertical = 8;
                  };
                  outer = {
                    bottom = 8;
                    left = 8;
                    right = 8;
                    top = 8;
                  };
                };
              };
            };
          })
        ]
      );
    };
}
