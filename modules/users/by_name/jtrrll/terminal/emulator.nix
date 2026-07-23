{
  config,
  lib,
  options,
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
          theme = "VS Code";
          window-padding-x = 8;
          window-padding-y = 8;
        };
        themes."VS Code" = {
          palette = [
            "0=#181818"
            "1=#f44747"
            "2=#6a9955"
            "3=#dcdcaa"
            "4=#569cd6"
            "5=#c586c0"
            "6=#9cdcfe"
            "7=#cccccc"
            "8=#6e7681"
            "9=#ce9178"
            "10=#4ec9b0"
            "11=#dcdcaa"
            "12=#569cd6"
            "13=#c586c0"
            "14=#9cdcfe"
            "15=#e5e5e5"
          ];
          background = "#1f1f1f";
          foreground = "#cccccc";
        };
      };
    })
    (lib.mkIf (options ? stylix) { stylix.targets.ghostty.colors.enable = false; })
  ];
}
