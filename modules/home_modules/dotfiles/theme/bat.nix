{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.theme.enable {
    programs.bat.config.theme = "Visual Studio Dark+";
    stylix.targets.bat.enable = false;
  };
}
