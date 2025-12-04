{
  homeManager,
  homeModules,
  overlay,
}:
{ lib, ... }:
{
  home-manager = {
    backupFileExtension = "bak";
    sharedModules = lib.attrValues homeModules;
  };
  imports = [ homeManager ];
  nixpkgs.overlays = [ overlay ];
}
