{
  homeManager,
  homeModules,
  nixpkgs,
  overlay,
}:
{ lib, pkgs, ... }:
{
  home-manager = {
    backupFileExtension = "bak";
    sharedModules = lib.attrValues homeModules;
    useUserPkgs = true;
    extraSpecialArgs = {
      pkgs = import nixpkgs {
        inherit (pkgs) system;
        overlays = [ overlay ];
      };
    };
  };
  imports = [ homeManager ];
  nixpkgs.overlays = [ overlay ];
}
