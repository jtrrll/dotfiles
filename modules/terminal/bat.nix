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
        programs.bat = {
          config.theme = "Visual Studio Dark+";
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batgrep
            batman
          ];
        };
      }
      (lib.mkIf (options ? stylix) { stylix.targets.bat.enable = false; })
    ]
  );
}
