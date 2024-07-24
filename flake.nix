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
  };

  outputs = {
    devenv,
    flake-parts,
    home-manager,
    nix-vscode-extensions,
    nixpkgs,
    ...
  } @ inputs: let
    home = import ./home.nix;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        inherit home;
        homeConfigurations = let
          mkHomeConfiguration = {
            args,
            pkgs,
          }:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [home {_module.args = args;}];
            };
          ### start "impure" ###
          HOME = builtins.getEnv "HOME";
          SYSTEM = builtins.currentSystem;
          USER = builtins.getEnv "USER";
          ### end "impure" ###
          pkgs = nixpkgs.legacyPackages.${SYSTEM};
          vscode-extensions = nix-vscode-extensions.extensions.${SYSTEM};
        in {
          # default configuration
          "${USER}" = mkHomeConfiguration {
            inherit pkgs;
            args = {
              inherit vscode-extensions;
              homeDirectory = HOME;
              username = USER;
            };
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
