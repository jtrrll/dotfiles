{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.fastfetch = {
      enable = true;
    };
  };
}
