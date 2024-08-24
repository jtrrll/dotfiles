{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.nixvim.plugins.indent-blankline = {
      enable = true;
      settings = {
        scope.enabled = true;
      };
    };
  };
}
