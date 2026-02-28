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
      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          (lib.mkIf pkgs.stdenv.isDarwin {
            programs.aerospace = {
              enable = true;
              launchd.enable = true;
              settings = {
                gaps = {
                  inner.horizontal = 8;
                  inner.vertical = 8;
                  outer.bottom = 8;
                  outer.left = 8;
                  outer.right = 8;
                  outer.top = 8;
                };
              };
            };
          })
        ]
      );

      options.dotfiles.windowManager = {
        enable = lib.mkEnableOption "jtrrll's window manager configuration";
      };
    };
}
