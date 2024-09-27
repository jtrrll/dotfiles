{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.fastfetch.enable {
    programs.fastfetch.enable = true;
  };

  options = {
    dotfiles.programs.fastfetch = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable fastfetch.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
