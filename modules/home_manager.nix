{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules = {
    homeManager.homeManager =
      {
        config,
        lib,
        ...
      }:
      {
        options.dotfiles.homeManager = {
          enable = lib.mkEnableOption "jtrrll's home-manager configuration" // {
            default = true;
          };
        };

        config = lib.mkIf config.dotfiles.homeManager.enable {
          news.display = "silent";
          programs.home-manager.enable = true;
          services.home-manager.autoExpire.enable = true;
        };
      };
    nixos.homeManager =
      { lib, pkgs, ... }:
      {
        home-manager = {
          backupFileExtension = "bak";
          sharedModules = lib.attrValues self.homeModules;
          useUserPackages = true;
          extraSpecialArgs = {
            pkgs = import inputs.nixpkgs-home-manager {
              inherit (pkgs) system;
            };
          };
        };
        imports = [ inputs.home-manager.nixosModules.home-manager ];
      };
  };
}
