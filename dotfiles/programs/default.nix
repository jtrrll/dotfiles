{lib, ...}:
with lib; {
  imports = [
    ./editors
    ./shells

    ./alacritty.nix
    ./bat.nix
    ./btop.nix
    ./eza.nix
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./zellij.nix
    ./zoxide.nix
  ];
  options = {
    dotfiles.programs = {
      enable = mkEnableOption "A collection of useful program configurations.";
    };
  };
}
