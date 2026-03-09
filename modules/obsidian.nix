{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.dotfiles =
    {
      lib,
      ...
    }:
    {
      config.programs.obsidian.enable = lib.mkDefault true;
    };
}
