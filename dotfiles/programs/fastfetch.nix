{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.fastfetch.enable {
    programs.fastfetch.enable = true;
  };

  options = {
    dotfiles.programs.fastfetch = {
      enable = lib.mkEnableOption "fastfetch";
    };
  };
}
