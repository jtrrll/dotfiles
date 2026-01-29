{
  libretro-shaders-slang,
  writeText,
}:
writeText "crt.slangp" ''
  #reference "${libretro-shaders-slang}/share/libretro/shaders/shaders_slang/crt/newpixie-crt.slangp"
  blur_x = "0.750000"
  blur_y = "0.750000"
  curvature = "0.000100"
''
