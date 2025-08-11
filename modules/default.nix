{ inputs, ... }:
{
  imports = [
    ./home_modules
    ./packages
    ./scripts

    ./checks.nix
    ./devenv.nix
    ./home_configurations.nix
    ./lib.nix
    ./overlays.nix
  ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
  systems = inputs.nixpkgs.lib.systems.flakeExposed;
}
