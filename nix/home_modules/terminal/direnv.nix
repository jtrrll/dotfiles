{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.terminal.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
