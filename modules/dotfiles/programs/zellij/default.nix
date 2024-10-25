{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.zellij.enable {
    programs.zellij = {
      enable = true;
    };

    home = {
      file.layouts = {
        source = ./layouts;
        target = "${config.dotfiles.homeDirectory}/.config/zellij/layouts";
      };
      shellAliases = {
        zedit = "zellij --layout editor"; # starts zellij with the editor layout
      };
    };
  };

  options = {
    dotfiles.programs.zellij = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable Zellij.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
