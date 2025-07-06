{lib, ...}: {
  flake.lib = builtins.addErrorContext "while defining lib" {
    filterAvailable = system: pkgsList: builtins.filter (pkg: lib.meta.availableOn system pkg) pkgsList;
  };
}
