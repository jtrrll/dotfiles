{
  config,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs = {
        eza.enable = lib.mkDefault true;
        fd.enable = lib.mkDefault true;
        fzf.enable = lib.mkDefault true;
        ripgrep.enable = lib.mkDefault true;
        snekcheck.enable = lib.mkDefault true;
        zoxide.enable = lib.mkDefault true;
      };
    }
    (lib.mkIf config.programs.eza.enable {
      programs.eza = {
        extraOptions = [ "--header" ];
        git = true;
        icons = "auto";
      };
    })
    (lib.mkIf config.programs.zoxide.enable {
      programs.zoxide.options = [ "--cmd cd" ];
    })
  ];
}
