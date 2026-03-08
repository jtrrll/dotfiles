{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    ### Flake dependencies ###
    # keep-sorted start block=yes
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # keep-sorted end

    ### Development dependencies ###
    # keep-sorted start block=yes
    devenv.url = "github:cachix/devenv";
    justix = {
      inputs.nixpkgs.follows = "devenv/nixpkgs";
      url = "github:jtrrll/justix";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "devenv/nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    # keep-sorted end

    ### Home Manager dependencies ###
    # keep-sorted start block=yes
    home-manager.url = "github:nix-community/home-manager";
    nixvim = {
      inputs.nixpkgs.follows = "home-manager/nixpkgs";
      url = "github:nix-community/nixvim";
    };
    snekcheck = {
      inputs.nixpkgs.follows = "home-manager/nixpkgs";
      url = "github:jtrrll/snekcheck";
    };
    stylix = {
      inputs.nixpkgs.follows = "home-manager/nixpkgs";
      url = "github:danth/stylix";
    };
    # keep-sorted end

    ### NixOS dependencies ###
    # keep-sorted start block=yes
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    # keep-sorted end
  };

  outputs =
    {
      flake-parts,
      import-tree,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, self, ... }:
      let
        modules-tree = lib.pipe import-tree [
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

          systems = lib.systems.flakeExposed;
        };
      }
    );
}
