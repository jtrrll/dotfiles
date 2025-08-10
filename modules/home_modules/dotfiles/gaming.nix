{
  config,
  lib,
  lib',
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.gaming.enable {
    home.packages = lib'.filterAvailable pkgs.stdenv.system [
      pkgs.prismlauncher
      pkgs.steam-rom-manager
    ];
    programs.vesktop.enable = true;
  };

  options.dotfiles.gaming = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the gaming configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
