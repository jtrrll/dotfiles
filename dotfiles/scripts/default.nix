{lib, ...}:
with lib; {
  imports = [
    ./home.nix
    ./repeat.nix
  ];
  options = {
    dotfiles.scripts = {
      enable = mkOption {
        default = true;
        description = "Whether to enable a collection of useful scripts.";
        type = types.bool;
      };
    };
  };
}
