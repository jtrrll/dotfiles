{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules = {
    homeManager.homeManager =
      {
        config,
        lib,
        ...
      }:
      {
        config = lib.mkIf config.dotfiles.homeManager.enable {
          news.display = "silent";
          programs.home-manager.enable = true;
          services.home-manager.autoExpire.enable = true;
        };

        options.dotfiles.homeManager = {
          enable = lib.mkEnableOption "jtrrll's home-manager configuration";
        };
      };
    nixos.homeManager =
      let
        overlay = self.overlays.default;
      in
      { lib, pkgs, ... }:
      {
        home-manager = {
          backupFileExtension = "bak";
          sharedModules = lib.attrValues self.homeModules;
          useUserPackages = true;
          extraSpecialArgs = {
            pkgs = import inputs.nixpkgs-home-manager {
              inherit (pkgs) system;
              overlays = [ overlay ];
            };
          };
        };
        imports = [ inputs.home-manager.nixosModules.home-manager ];
        nixpkgs.overlays = [ overlay ];
      };
  };
}
