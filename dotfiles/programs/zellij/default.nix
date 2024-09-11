{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.zellij.enable {
    programs.zellij = {
      enable = true;
    };

    home.file."layouts" = {
      source = ./layouts;
      target = "${config.dotfiles.homeDirectory}/.config/zellij/layouts";
    };
  };

  options = {
    dotfiles.programs.zellij = {
      enable = lib.mkEnableOption "Zellij";
    };
  };
}
