{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.bat.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batdiff batgrep batman];
    };
    home.shellAliases = {
      cat = "bat --paging=never";
      diff = "batdiff";
      grep = "batgrep";
      man = "batman";
    };
  };

  options.dotfiles.bat = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable `bat`.";
      example = false;
      type = lib.types.bool;
    };
  };
}
