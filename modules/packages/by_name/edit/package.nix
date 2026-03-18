{ lib, writers }:
lib.addMetaAttrs {
  description = "Launches a text editor";
  license = lib.licenses.agpl3Plus;
  platforms = lib.platforms.all;
  sourceProvenance = [ lib.sourceTypes.fromSource ];
} (writers.writeNuBin "edit" { } (lib.readFile ./edit.nu))
