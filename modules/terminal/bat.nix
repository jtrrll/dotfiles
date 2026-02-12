{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.bat.enable (
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
      (lib.optionalAttrs (options ? stylix) { stylix.targets.bat.enable = false; })
    ]
  );

  options.dotfiles.bat = {
    enable = lib.mkEnableOption "jtrrll's bat configuration";
  };
}
