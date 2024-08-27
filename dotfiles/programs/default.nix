{lib, ...}:
with lib; {
  imports = [
    ./editors
    ./shells
    ./zellij

    ./alacritty.nix
    ./bat.nix
    ./btop.nix
    ./eza.nix
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./zoxide.nix
  ];
  options = {
    dotfiles.programs = {
      enable = mkEnableOption "A collection of useful program configurations.";
    };
  };
}
