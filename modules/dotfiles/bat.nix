{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.bat.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batgrep batman];
    };
    home.shellAliases = {
      cat = "bat --paging=never"; # print file (replaces cat)
      grep = "batgrep"; # ripgrep with bat as the formatter (replaces grep)
      man = "batman"; # read manual pages with bat as the formatter
    };
  };

  options.dotfiles.bat = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable bat.";
      example = false;
      type = lib.types.bool;
    };
  };
}
