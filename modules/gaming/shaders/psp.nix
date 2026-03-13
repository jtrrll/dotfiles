{
  libretro-shaders-slang,
  writeText,
}:
(writeText "psp.slangp" ''
  #reference "${libretro-shaders-slang}/share/libretro/shaders/shaders_slang/presets/handheld-plus-color-mod/lcd-grid-v2-psp-color.slangp"
'').overrideAttrs
  (oldAttrs: {
    meta = (oldAttrs.meta or { }) // {
      inherit (libretro-shaders-slang.meta) license;
      description = "A PSP shader that replicates original hardware";
    };
  })
