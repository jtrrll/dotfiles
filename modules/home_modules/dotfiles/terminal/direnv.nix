{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
