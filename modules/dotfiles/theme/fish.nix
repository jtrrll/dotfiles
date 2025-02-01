{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.dotfiles.theme.enable && config.dotfiles.theme.classicCode) {
    stylix.targets.fish.enable = false;
  };
}
