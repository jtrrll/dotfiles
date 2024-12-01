{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.file-system.enable {
    programs = {
      eza = {
        enable = true;
        extraOptions = ["--header"];
        git = true;
        icons = "auto";
      };
      fzf.enable = true;
      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
    };
  };
}
