{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.notes =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.dotfiles.notes;
    in
    {
      options.dotfiles.notes = {
        enable = lib.mkEnableOption "jtrrll's note taking configuration" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.obsidian.enable = true;
      };
    };
}
