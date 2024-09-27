{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.theme.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.ibm-plex
      pkgs.monocraft
      (pkgs.nerdfonts.override {fonts = ["Hack"];})
    ];
  };
}
