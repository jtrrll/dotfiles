{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.file-system.enable {
    home.packages = [
      pkgs.snek-check
    ];
    programs = {
      eza = {
        enable = true;
        extraOptions = ["--header"];
        git = true;
        icons = true;
      };
      fzf.enable = true;
      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
    };
  };

  options.dotfiles.file-system = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the file-system configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
