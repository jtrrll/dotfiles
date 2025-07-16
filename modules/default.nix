{inputs, ...}: {
  imports = [
    ./checks
    ./devenv
    ./home_configurations
    ./home_modules
    ./lib
    ./overlays
    ./packages
    ./scripts
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };

  systems = inputs.nixpkgs.lib.systems.flakeExposed;
}
