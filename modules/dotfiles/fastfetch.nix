{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.fastfetch.enable {
    programs.fastfetch.enable = true;
  };

  options.dotfiles.fastfetch = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable fastfetch.";
      example = false;
      type = lib.types.bool;
    };
  };
}
