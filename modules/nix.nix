{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules = {
    homeManager.dotfiles =
      {
        config,
        lib,
        ...
      }:
      {
        config = lib.mkMerge [
          { programs.nh.enable = lib.mkDefault true; }
          (lib.mkIf config.programs.nh.enable {
            programs.nh.clean.enable = true;
          })
        ];
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
