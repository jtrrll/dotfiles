{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.theme.enable {
    stylix.targets.fish.enable = false;
  };
}
