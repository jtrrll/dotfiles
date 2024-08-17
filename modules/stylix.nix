{
  args,
  pkgs,
  ...
}: let
  backgroundPath = "${args.homeDirectory}/.config/background";
in {
  stylix = {
    enable = builtins.pathExists backgroundPath;
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 28;
    };
    fonts = {
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["Hack"];};
        name = "Hack Nerd Font Mono";
      };
    };
    image = builtins.fetchurl {
      url = "file://${backgroundPath}";
    };
    targets = {
      alacritty.enable = false;
      bat.enable = false;
      nixvim.enable = false;
      vscode.enable = false;
      zellij.enable = false;
    };
  };
}
