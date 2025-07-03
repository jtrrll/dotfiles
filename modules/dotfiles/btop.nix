{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.btop.enable {
    programs.btop = {
      enable = true;
      settings.theme_background = false;
    };
  };

  options.dotfiles.btop = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable `btop`.";
      example = false;
      type = lib.types.bool;
    };
  };
}
