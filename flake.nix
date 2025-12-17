{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    ### Development dependencies ###
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devenv = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cachix/devenv";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    justix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jtrrll/justix";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };

    ### Home Manager dependencies ###
    nixpkgs-home-manager.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs-home-manager";
      url = "github:nix-community/home-manager";
    };
    nix-vscode-extensions = {
      inputs.nixpkgs.follows = "nixpkgs-home-manager";
      url = "github:nix-community/nix-vscode-extensions";
    };
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs-home-manager";
      url = "github:nix-community/nixvim";
    };
    snekcheck = {
      inputs.nixpkgs.follows = "nixpkgs-home-manager";
      url = "github:jtrrll/snekcheck";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs-home-manager";
      url = "github:danth/stylix";
    };

    ### NixOS dependencies ###
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
