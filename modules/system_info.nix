{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.dotfiles =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          programs = {
            btop.enable = lib.mkDefault true;
            fastfetch.enable = lib.mkDefault true;
          };
        }
        (lib.mkIf config.programs.btop.enable {
          programs.btop.settings.theme_background = false;
        })
      ];
    };
}
