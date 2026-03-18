{
  lib,
  libretro-shaders-slang,
  writeText,
}:
lib.addMetaAttrs
  {
    inherit (libretro-shaders-slang.meta) license;
    description = "A PSP shader that replicates original hardware";
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  }
  (
    writeText "psp.slangp" ''
      #reference "${libretro-shaders-slang}/share/libretro/shaders/shaders_slang/presets/handheld-plus-color-mod/lcd-grid-v2-psp-color.slangp"
    ''
  )
