{ constants }:
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.terminal.enable (
    lib.mkMerge [
      {
        fonts.fontconfig.enable = true;
        home = {
          packages = [ pkgs.nerd-fonts.hack ];
          sessionVariables.SHELL = "${config.programs.fish.package}/bin/fish";
        };
        programs.ghostty = {
          enable = true;
          installBatSyntax = !pkgs.stdenv.isDarwin;
          installVimSyntax = !pkgs.stdenv.isDarwin;
          settings = {
            auto-update = "off";
            command = "${config.programs.zellij.package}/bin/zellij";
            font-family = "Hack Nerd Font Mono";
            font-thicken = true;
            theme = "VS Code";
            window-padding-x = 8;
            window-padding-y = 8;
          };
          themes."VS Code" = with constants.COLOR; {
            palette = [
              "0=${BLACK}"
              "1=${RED}"
              "2=${GREEN}"
              "3=${YELLOW}"
              "4=${BLUE}"
              "5=${PINK}"
              "6=${CYAN}"
              "7=${SILVER}"
              "8=${GRAY}"
              "9=${ORANGE}"
              "10=${TEAL}"
              "11=${YELLOW}"
              "12=${BLUE}"
              "13=${PINK}"
              "14=${CYAN}"
              "15=${WHITE}"
            ];
            background = DARK_GRAY;
            foreground = SILVER;
          };
        };
      }
      (if options ? stylix then { stylix.targets.ghostty.enable = false; } else { })
    ]
  );
}
