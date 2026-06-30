{
  description = "jtrrll's declarative dotfiles";

  nixConfig.allow-import-from-derivation = false;

  inputs = {
    ### Flake dependencies ###
    # keep-sorted start block=yes
    files = {
      flake = false;
      url = "github:mightyiam/files/master";
    };
    flake-parts.url = "github:hercules-ci/flake-parts/main";
    import-tree.url = "github:denful/import-tree/main";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix/main";
    };
    # keep-sorted end

    ### Development dependencies ###
    # keep-sorted start block=yes
    devenv.url = "github:cachix/devenv/main";
    # keep-sorted end

    ### Home Manager dependencies ###
    # keep-sorted start block=yes
    home-manager.url = "github:nix-community/home-manager/master";
    nixvim.url = "github:nix-community/nixvim/main";
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
    disko = {
      inputs.nixpkgs.follows = "determinate/nixpkgs";
      url = "github:nix-community/disko/master";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # keep-sorted end

    ### Infrastructure dependencies ###
    # keep-sorted start block=yes
    terranix.url = "github:terranix/terranix/main";
    # keep-sorted end
  };

  outputs =
    {
      flake-parts,
      import-tree,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        lib,
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
        imports = [
          inputs.devenv.flakeModule
          (inputs.files + "/flake-module.nix")
          inputs.flake-parts.flakeModules.flakeModules
          inputs.flake-parts.flakeModules.modules
          inputs.flake-parts.flakeModules.touchup
          inputs.home-manager.flakeModules.home-manager
          inputs.terranix.flakeModule
          inputs.treefmt-nix.flakeModule
          modules-tree.result
        ];

        config = {
          flake.flakeModules = config.flake.modules.flake // {
            default = {
              imports = lib.attrValues config.flake.modules.flake;
            };
          };
          perSystem = _: {
            terranix.exportDevShells = false;
          };
          systems = [
            # keep-sorted start
            "aarch64-darwin"
            "aarch64-linux"
            "x86_64-linux"
            # keep-sorted end
          ];
          touchup = {
            any.enable = lib.mkDefault false;
            attr = {
              # keep-sorted start block=yes
              apps.enable = true;
              checks.enable = true;
              devShells.enable = true;
              flakeModules.enable = true;
              formatter.enable = true;
              homeConfigurations.enable = true;
              homeModules.enable = true;
              nixosConfigurations.enable = true;
              nixosModules.enable = true;
              packages.enable = true;
              # keep-sorted end
            };
          };
        };
      }
    );
}
