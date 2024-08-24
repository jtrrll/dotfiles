{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.zoxide = {
      enable = true;
    };
  };
}
