{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };

  options = {
    dotfiles.programs.direnv = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable direnv.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
