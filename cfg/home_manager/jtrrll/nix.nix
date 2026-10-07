{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { programs.nh.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.nh.enable {
      programs.nh.clean.enable = true;
    })
    {
      home.packages = [
        # keep-sorted start
        pkgs.nix-eval-jobs
        pkgs.nix-fast-build
        pkgs.nix-output-monitor
        pkgs.nix-tree
        # keep-sorted end
      ];
    }
  ];
}
