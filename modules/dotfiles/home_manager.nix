{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.home-manager.enable {
    programs.home-manager.enable = true;
  };

  options.dotfiles.home-manager = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable home-manager.";
      example = false;
      type = lib.types.bool;
    };
  };
}
