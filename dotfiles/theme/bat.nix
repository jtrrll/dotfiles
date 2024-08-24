{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf (config.dotfiles.theme.enable && config.dotfiles.theme.classicCode) {
    programs.bat = {
      config.theme = "Visual Studio Dark+";
    };
    stylix.targets.bat.enable = false;
  };
}
