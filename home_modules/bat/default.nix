{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.bat.enable (
    lib.mkMerge [
      {
        home.shellAliases = {
          cat = "bat --paging=never";
          diff = "batdiff";
          grep = "batgrep";
          man = "batman";
        };
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
      (if options ? stylix then { stylix.targets.bat.enable = false; } else { })
    ]
  );

  options.jtrrllDotfiles.bat = {
    enable = lib.mkEnableOption "jtrrll's bat configuration";
  };
}
