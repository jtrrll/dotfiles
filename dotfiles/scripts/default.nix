{lib, ...}:
with lib; {
  imports = [
    ./home.nix
    ./repeat.nix
  ];
  options = {
    dotfiles.scripts = {
      enable = mkEnableOption "A collection of useful scripts.";
    };
  };
}
