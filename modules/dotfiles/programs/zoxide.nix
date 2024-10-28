{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.zoxide.enable {
    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
  };

  options = {
    dotfiles.programs.zoxide = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable zoxide.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
