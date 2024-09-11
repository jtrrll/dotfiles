{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.home-manager.enable {
    programs.home-manager.enable = true;
  };

  options = {
    dotfiles.programs.home-manager = {
      enable = lib.mkEnableOption "home-manager";
    };
  };
}
