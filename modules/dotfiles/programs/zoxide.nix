{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.zoxide.enable {
    programs.zoxide.enable = true;
    home.shellAliases = {
      cd = "z"; # change directory (replaces cd)
      cdi = "zi"; # change directory with an interactive fuzzy finder
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
