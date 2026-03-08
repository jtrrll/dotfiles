{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules = {
    homeManager.dotfiles =
      {
        lib,
        ...
      }:
      {
        config = {
          news.display = "silent";
          programs.home-manager.enable = lib.mkDefault true;
          services.home-manager.autoExpire.enable = lib.mkDefault true;
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
            pkgs = inputs.home-manager.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
          };
        };
        imports = [ inputs.home-manager.nixosModules.home-manager ];
      };
  };
}
