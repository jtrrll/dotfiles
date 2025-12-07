{ lib, ... }:
{
  flake.lib = {
    filterAvailable =
      system: pkgsList:
      builtins.filter (pkg: (builtins.tryEval (lib.meta.availableOn system pkg)).value) pkgsList;
  };
}
