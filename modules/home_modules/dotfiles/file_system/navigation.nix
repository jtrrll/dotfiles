{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.file-system.enable {
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
}
