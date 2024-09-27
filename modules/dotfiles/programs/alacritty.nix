{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        cursor = {
          blink_interval = 500;
          style = {
            blinking = "Always";
            shape = "Beam";
          };
          unfocused_hollow = true;
        };
        window.padding = {
          x = 8;
          y = 8;
        };
      };
    };
  };

  options = {
    dotfiles.programs.alacritty = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable Alacritty.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
