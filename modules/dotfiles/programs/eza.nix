{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.eza.enable {
    programs.eza = {
      enable = true;
      extraOptions = ["--header"];
      git = true;
      icons = true;
    };
  };

  options = {
    dotfiles.programs.eza = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable eza.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
