{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.system-info.enable {
    programs = {
      btop = {
        enable = true;
        settings.theme_background = false;
      };
      fastfetch.enable = true;
    };
  };

  options.dotfiles.system-info = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the system information configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
