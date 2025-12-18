{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.fileSystem.enable {
    home.packages = [
      pkgs.snekcheck
    ];
    programs = {
      eza = {
        enable = true;
        extraOptions = [ "--header" ];
        git = true;
        icons = "auto";
      };
      fd.enable = true;
      fzf.enable = true;
      ripgrep.enable = true;
      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
    };
  };

  options.dotfiles.fileSystem = {
    enable = lib.mkEnableOption "jtrrll's file-system configuration";
  };
}
