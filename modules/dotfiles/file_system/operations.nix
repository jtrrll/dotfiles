{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.file-system.enable {
    home.packages = [
      pkgs.snekcheck
    ];
  };
}
