{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    devenv.url = "github:cachix/devenv";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    devenv,
    flake-utils,
    home-manager,
    nix-vscode-extensions,
    nixpkgs,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      vscode-extensions = nix-vscode-extensions.extensions.${system};
    in {
      devShells = {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            ({pkgs, ...}: {
              enterShell = ''
                printf "    ▓█████▄  ▒█████  ▄▄▄█████▓  █████▒██▓ ██▓    ▓█████   ██████
                    ▒██▀ ██▌▒██▒  ██▒▓  ██▒ ▓▒▓██   ▒▓██▒▓██▒    ▓█   ▀ ▒██    ▒
                    ░██   █▌▒██░  ██▒▒ ▓██░ ▒░▒████ ░▒██▒▒██░    ▒███   ░ ▓██▄
                    ░▓█▄   ▌▒██   ██░░ ▓██▓ ░ ░▓█▒  ░░██░▒██░    ▒▓█  ▄   ▒   ██▒
                ██▓ ░▒████▓ ░ ████▓▒░  ▒██▒ ░ ░▒█░   ░██░░██████▒░▒████▒▒██████▒▒
                ▒▓▒  ▒▒▓  ▒ ░ ▒░▒░▒░   ▒ ░░    ▒ ░   ░▓  ░ ▒░▓  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
                ░▒   ░ ▒  ▒   ░ ▒ ▒░     ░     ░      ▒ ░░ ░ ▒  ░ ░ ░  ░░ ░▒  ░ ░
                ░    ░ ░  ░ ░ ░ ░ ▒    ░       ░ ░    ▒ ░  ░ ░      ░   ░  ░  ░
                  ░     ░        ░ ░                   ░      ░  ░   ░  ░      ░
                  ░   ░\n" | ${pkgs.lolcat}/bin/lolcat
                printf "\033[0;1;36mDEVSHELL ACTIVATED\033[0m\n"
              '';
              languages = {
                nix.enable = true;
              };
              packages = [
                pkgs.commitizen
              ];
              pre-commit = {
                default_stages = ["pre-push"];
                hooks = {
                  actionlint.enable = true;
                  alejandra.enable = true;
                  check-added-large-files = {
                    enable = true;
                    stages = ["pre-commit"];
                  };
                  check-yaml.enable = true;
                  commitizen.enable = true;
                  deadnix.enable = true;
                  detect-private-keys = {
                    enable = true;
                    stages = ["pre-commit"];
                  };
                  end-of-file-fixer.enable = true;
                  flake-checker.enable = true;
                  markdownlint.enable = true;
                  mixed-line-endings.enable = true;
                  nil.enable = true;
                  no-commit-to-branch = {
                    enable = true;
                    stages = ["pre-commit"];
                  };
                  ripsecrets = {
                    enable = true;
                    stages = ["pre-commit"];
                  };
                  shellcheck.enable = true;
                  shfmt.enable = true;
                  statix.enable = true;
                };
              };
            })
          ];
        };
      };
      formatter = pkgs.alejandra;
      packages = {
        homeConfigurations = let
          USER = builtins.getEnv "USER";
          HOME = builtins.getEnv "HOME";

          mkHomeConfiguration = {
            username ? USER,
            homeDirectory ? HOME,
          }:
            home-manager.lib.homeManagerConfiguration {
              modules = [./home.nix];
              inherit pkgs;
              extraSpecialArgs = {
                inherit username homeDirectory vscode-extensions;
                colors = import ./modules/colors.nix;
              };
            };
        in {
          "${USER}" = mkHomeConfiguration {}; # default configuration
        };
      };
    });
}
