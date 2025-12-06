{ config, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        options = pkgs.callPackage ./options.nix {
          inherit (config.flake) homeModules;
        };
      };
    };
}
