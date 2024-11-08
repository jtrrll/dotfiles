{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.file-system.enable {
    programs = {
      fzf.enable = true;
      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
    };
  };
}
