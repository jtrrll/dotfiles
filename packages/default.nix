{ config, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = builtins.addErrorContext "while defining packages" {
        options = pkgs.callPackage ./options.nix {
          inherit (config.flake) homeModules;
        };
      };
    };
}
