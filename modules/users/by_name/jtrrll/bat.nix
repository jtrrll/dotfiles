{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { programs.bat.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.bat.enable {
      programs.bat = {
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
        ];
      };
    })
  ];
}
