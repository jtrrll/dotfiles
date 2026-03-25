{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { programs.bat.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.bat.enable {
      programs.bat = {
        config.theme = "Visual Studio Dark+";
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
        ];
      };
    })
    (lib.mkIf (options ? stylix) { stylix.targets.bat.enable = false; })
  ];
}
