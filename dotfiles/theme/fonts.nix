{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.theme.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      ibm-plex
      monocraft
      (nerdfonts.override {fonts = ["Hack"];})
    ];
  };
}
