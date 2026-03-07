{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    ### Development dependencies ###
    # keep-sorted start
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
    # keep-sorted end

    ### Home Manager dependencies ###
    # keep-sorted start
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs-home-manager.follows = "home-manager/nixpkgs";
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
    # keep-sorted end

    ### NixOS dependencies ###
    # keep-sorted start
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # keep-sorted end
  };

  outputs =
    {
      flake-parts,
      import-tree,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, self, ... }:
      let
        modules-tree = nixpkgs.lib.pipe import-tree [
          (it: it.withLib lib)
          (it: it.addPath ./modules)
          # Matches top-level `*.nix` files and `default.nix` files that are one level deep.
          (it: it.match "^/[^/]+\.nix$|^/[^/]+/default\.nix$")
        ];
      in
      {
        imports = [
          ./dev_shells
          ./home_configurations
          ./nixos_configurations
          modules-tree.result
        ];

        options = {
          flake.lib = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "A top-level library";
          };
        };

        config = {
          flake = {
            lib.modules-tree = modules-tree;
            homeModules = self.modules.homeManager;
            nixosModules = self.modules.nixos;
          };

          systems = nixpkgs.lib.systems.flakeExposed;
        };
      }
    );
}
