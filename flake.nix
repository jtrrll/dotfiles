{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    devenv.url = "github:cachix/devenv";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    devenv,
    home-manager,
    nix-vscode-extensions,
    nixpkgs,
    ...
  } @ inputs: let
    constants = import ./constants.nix;
    lib = import ./lib.nix {
      inherit home-manager;
    };
  in {
    inherit constants lib;
    devShells = lib.forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [./devshell.nix];
      };
    });
    formatter = lib.forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
    homeConfigurations = let
      ### start "impure" ###
      HOME = builtins.getEnv "HOME";
      SYSTEM = builtins.currentSystem;
      USER = builtins.getEnv "USER";
      ### end "impure" ###
      pkgs = nixpkgs.legacyPackages.${SYSTEM};
      vscode-extensions = nix-vscode-extensions.extensions.${SYSTEM};
    in {
      # default configuration
      "${USER}" = lib.mkHomeConfiguration {
        inherit pkgs vscode-extensions;
        username = USER;
        homeDirectory = HOME;
      };
    };
  };
}
