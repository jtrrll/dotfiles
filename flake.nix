{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = {
    devenv,
    flake-parts,
    home-manager,
    nix-vscode-extensions,
    nixpkgs,
    nixvim,
    stylix,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = let
        home = import ./home.nix {
          inherit (nixvim.homeManagerModules) nixvim;
          inherit (stylix.homeManagerModules) stylix;
          constants = import ./constants.nix;
        };
        overlay = final: _: {
          vscode-extensions = nix-vscode-extensions.extensions.${final.system}.vscode-marketplace;
        };
      in {
        inherit home overlay;
        homeConfigurations = let
          ### start "impure" ###
          HOME = builtins.getEnv "HOME";
          SYSTEM = builtins.currentSystem;
          USER = builtins.getEnv "USER";
          ### end "impure" ###
        in {
          # default configuration
          "${USER}" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              inherit SYSTEM;
              overlays = [overlay];
            };
            modules = [
              (home {
                homeDirectory = HOME;
                username = USER;
              })
            ];
          };
        };
      };
      perSystem = {pkgs, ...}: {
        devShells.default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [./devshell.nix];
        };
        formatter = pkgs.alejandra;
      };
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
