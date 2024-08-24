{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.eza = {
      enable = true;
      extraOptions = ["--header"];
      git = true;
      icons = true;
    };
  };
}
