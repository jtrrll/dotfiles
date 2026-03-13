{
  libretro-shaders-slang,
  writeText,
}:
(writeText "crt.slangp" ''
  #reference "${libretro-shaders-slang}/share/libretro/shaders/shaders_slang/crt/newpixie-crt.slangp"
  blur_x = "0.750000"
  blur_y = "0.750000"
  curvature = "0.000100"
'').overrideAttrs
  (oldAttrs: {
    meta = (oldAttrs.meta or { }) // {
      inherit (libretro-shaders-slang.meta) license;
      description = "A CRT shader that blends pixels";
    };
  })
