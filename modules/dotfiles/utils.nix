{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.utils.enable {
    home.packages = [pkgs.uutils-coreutils-noprefix];
  };

  options.dotfiles.utils = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable utils.";
      example = false;
      type = lib.types.bool;
    };
  };
}
