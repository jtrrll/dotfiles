{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    devenv = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cachix/devenv";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    justix.url = "github:jtrrll/justix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };

    home-manager.url = "github:nix-community/home-manager";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs-home-manager.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    snekcheck.url = "github:jtrrll/snekcheck";
    stylix.url = "github:danth/stylix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
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
