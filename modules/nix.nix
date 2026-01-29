{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules = {
    homeManager.nix =
      {
        config,
        lib,
        ...
      }:
      {
        config = lib.mkIf config.dotfiles.nix.enable {
          programs.nh = {
            enable = true;
            clean.enable = true;
          };
        };

        options.dotfiles.nix = {
          enable = lib.mkEnableOption "jtrrll's Nix configuration";
        };
      };
    nixos.nix = {
      nix.settings = {
        extra-experimental-features = [
          "flakes"
          "nix-command"
        ];
        trusted-public-keys = [
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-substituters = [
          "https://devenv.cachix.org"
          "https://nix-community.cachix.org"
        ];
      };
    };
  };
}
