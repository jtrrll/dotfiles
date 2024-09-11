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
      enable = lib.mkEnableOption "fzf";
    };
  };
}
