{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    ### Flake dependencies ###
    # keep-sorted start block=yes
    files.url = "github:mightyiam/files/main";
    flake-parts.url = "github:hercules-ci/flake-parts/main";
    import-tree.url = "github:vic/import-tree/main";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # keep-sorted end

    ### Development dependencies ###
    # keep-sorted start block=yes
    devenv.url = "github:cachix/devenv/main";
    justix = {
      inputs.nixpkgs.follows = "devenv/nixpkgs";
      url = "github:jtrrll/justix/main";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "devenv/nixpkgs";
      url = "github:numtide/treefmt-nix/main";
    };
    # keep-sorted end

    ### Home Manager dependencies ###
    # keep-sorted start block=yes
    home-manager.url = "github:nix-community/home-manager/master";
    nixvim = {
      inputs.nixpkgs.follows = "home-manager/nixpkgs";
      url = "github:nix-community/nixvim/main";
    };
    snekcheck = {
      inputs.nixpkgs.follows = "home-manager/nixpkgs";
      url = "github:jtrrll/snekcheck/main";
    };
    stylix = {
      inputs.nixpkgs.follows = "home-manager/nixpkgs";
      url = "github:nix-community/stylix/master";
    };
    # keep-sorted end

    ### NixOS dependencies ###
    # keep-sorted start block=yes
    determinate.url = "github:DeterminateSystems/determinate/main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    # keep-sorted end
  };

  outputs =
    {
      determinate,
      flake-parts,
      import-tree,
      nixvim,
      stylix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        lib,
        self,
        ...
      }:
      let
        modules-tree = lib.pipe import-tree [
          (it: it.withLib lib)
          (it: it.addPath ./modules)
          (it: it.filterNot (lib.hasInfix "/by_name/"))
        ];
      in
      {
        imports = [ modules-tree.result ];

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
            homeModules = {
              inherit (nixvim.homeModules) nixvim;
              inherit (stylix.homeModules) stylix;
            }
            // lib.mapAttrs (_: module: {
              imports = [ module ];
              meta = {
                inherit (config.flake) maintainers;
              };
            }) self.modules.homeManager;
            nixosModules = {
              determinateNix = determinate.nixosModules.default;
            }
            // lib.mapAttrs (_: module: {
              imports = [ module ];
              meta = {
                inherit (config.flake) maintainers;
              };
            }) self.modules.nixos;
          };

          systems = lib.systems.flakeExposed;
        };
      }
    );
}
