{
  config,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.direnv.enable = lib.mkDefault true;
    }
    (lib.mkIf config.programs.direnv.enable {
      programs.direnv = {
        nix-direnv.enable = true;
        silent = true;
      };
    })
  ];
}
