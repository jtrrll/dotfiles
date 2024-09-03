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
      enable = mkOption {
        default = true;
        description = "Whether to enable a collection of useful program configurations.";
        type = types.bool;
      };
      editors = mkOption {
        default = ["neovim" "vscode"];
        description = ''
          A list of editors to be enabled. Valid values are:
          - "neovim"
          - "vscode"
        '';
        type = types.listOf (types.enum ["neovim" "vscode"]);
      };
    };
  };
}
