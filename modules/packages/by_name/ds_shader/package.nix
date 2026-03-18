{
  lib,
  libretro-shaders-slang,
  writeText,
}:
lib.addMetaAttrs
  {
    inherit (libretro-shaders-slang.meta) license;
    description = "A DS shader that replicates original hardware";
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  }
  (
    writeText "ds.slangp" ''
      #reference "${libretro-shaders-slang}/share/libretro/shaders/shaders_slang/presets/handheld-plus-color-mod/lcd-grid-v2-dslite-color.slangp"
    ''
  )
