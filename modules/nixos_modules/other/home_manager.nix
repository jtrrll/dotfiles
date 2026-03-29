{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.nixos.homeManager =
    { lib, pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      hmPkgs = inputs.home-manager.inputs.nixpkgs.legacyPackages.${system}.extend (
        _: _: self.packages.${system}
      );
    in
    {
      home-manager = {
        backupFileExtension = "bak";
        sharedModules = lib.attrValues self.homeModules;
        useUserPackages = true;
        extraSpecialArgs = {
          pkgs = hmPkgs;
        };
      };
      imports = [ inputs.home-manager.nixosModules.home-manager ];
    };
}
