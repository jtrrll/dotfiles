{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    devenv.url = "github:cachix/devenv";
    env-help.url = "github:jtrrll/env-help";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    snekcheck.url = "github:jtrrll/snekcheck";
    stylix.url = "github:danth/stylix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      flake-parts,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./checks
        ./dev_shells
        ./formatter
        ./home_configurations
        ./home_modules
        ./lib
        ./nixos_configurations
        ./nixos_modules
        ./overlays
        ./packages
        ./scripts
      ];
      systems = nixpkgs.lib.systems.flakeExposed;
    };
}
