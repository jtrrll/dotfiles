{ lib, writers }:
lib.addMetaAttrs {
  description = "Launches a text editor";
  platforms = lib.platforms.all;
  sourceProvenance = [ lib.sourceTypes.fromSource ];
} (writers.writeNuBin "edit" { } (lib.readFile ./edit.nu))
