{ constants }:
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.terminal.enable (
    lib.mkMerge [
      {
        fonts.fontconfig.enable = true;
        home = {
          packages = [ pkgs.nerd-fonts.hack ];
          sessionVariables.SHELL = lib.getExe config.programs.fish.package;
        };
        programs.ghostty = {
          enable = true;
          installBatSyntax = !pkgs.stdenv.isDarwin;
          installVimSyntax = !pkgs.stdenv.isDarwin;
          settings = {
            auto-update = "off";
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
      (lib.optionalAttrs (options ? stylix) { stylix.targets.ghostty.enable = false; })
    ]
  );
}
