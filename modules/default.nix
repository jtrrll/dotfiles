{inputs, ...}: {
  imports = [
    ./dotfiles
    ./packages
    ./scripts

    ./checks.nix
    ./configurations.nix
    ./devenv.nix
    ./lib.nix
    ./overlay.nix
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };

  systems = inputs.nixpkgs.lib.systems.flakeExposed;
}
