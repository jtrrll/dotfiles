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
    import-tree.url = "github:vic/import-tree";
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
      import-tree,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./dev_shells
        ./home_configurations
        ./nixos_configurations
        # Matches top-level `*.nix` files and `default.nix` files that are one level deep.
        (import-tree.match "^/[^/]+\.nix$|^/[^/]+/default\.nix$" ./modules)
      ];

      systems = nixpkgs.lib.systems.flakeExposed;
    };
}
