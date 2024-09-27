{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.fzf.enable {
    programs.fzf.enable = true;
  };

  options = {
    dotfiles.programs.fzf = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable fzf.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
