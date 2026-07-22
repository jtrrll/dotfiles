{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { programs.ghostty.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.ghostty.enable {
      fonts.fontconfig.enable = true;
      home = {
        packages = [ pkgs.nerd-fonts.hack ];
        sessionVariables.SHELL = lib.getExe config.programs.fish.package;
      };
      programs.ghostty = {
        installBatSyntax = !pkgs.stdenv.isDarwin;
        installVimSyntax = !pkgs.stdenv.isDarwin;
        package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
        settings = {
          auto-update = "off";
          font-family = "Hack Nerd Font Mono";
          font-thicken = true;
          window-padding-x = 8;
          window-padding-y = 8;
        };
      };
    })
  ];
}
