{
  config,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    { programs.nh.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.nh.enable {
      programs.nh.clean.enable = true;
    })
  ];
}
