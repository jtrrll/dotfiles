{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.fzf = {
      enable = true;
    };
  };
}
