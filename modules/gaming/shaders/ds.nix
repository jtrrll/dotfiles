{
  libretro-shaders-slang,
  writeText,
}:
(writeText "ds.slangp" ''
  #reference "${libretro-shaders-slang}/share/libretro/shaders/shaders_slang/presets/handheld-plus-color-mod/lcd-grid-v2-dslite-color.slangp"
'').overrideAttrs
  (oldAttrs: {
    meta = (oldAttrs.meta or { }) // {
      inherit (libretro-shaders-slang.meta) license;
      description = "A DS shader that replicates original hardware";
    };
  })
