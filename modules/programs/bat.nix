{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.theme = "Visual Studio Dark+";
    extraPackages = with pkgs.bat-extras; [batgrep batman];
  };
}
