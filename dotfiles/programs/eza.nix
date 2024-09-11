{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.eza.enable {
    programs.eza = {
      enable = true;
      extraOptions = ["--header"];
      git = true;
      icons = true;
    };
  };

  options = {
    dotfiles.programs.eza = {
      enable = lib.mkEnableOption "eza";
    };
  };
}
