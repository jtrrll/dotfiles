{ config, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.options = pkgs.callPackage ./options.nix {
        dotfilesModule = config.flake.homeModules.dotfiles;
      };
    };
}
