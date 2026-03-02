{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.dotfiles =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        { programs.aerospace.enable = lib.mkDefault pkgs.stdenv.isDarwin; }
        (lib.mkIf config.programs.aerospace.enable {
          programs.aerospace = {
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
      ];
    };
}
