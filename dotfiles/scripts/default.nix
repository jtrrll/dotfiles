{lib, ...}:
with lib; {
  imports = [
    ./home.nix
  ];
  options = {
    dotfiles.scripts = {
      enable = mkEnableOption "A collection of useful scripts.";
    };
  };
}
