{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.fileSystem.enable {
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

  options.jtrrllDotfiles.fileSystem = {
    enable = lib.mkEnableOption "jtrrll's file-system configuration";
  };
}
