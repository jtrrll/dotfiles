{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    ibm-plex
    monocraft
    (nerdfonts.override {fonts = ["Hack"];})
  ];
}
