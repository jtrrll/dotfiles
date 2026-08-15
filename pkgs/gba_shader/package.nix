{ mkSlangShader }:
mkSlangShader {
  name = "gba_shader";
  description = "A GBA shader that replicates original hardware";
  passes = [
    { shader = "handheld/shaders/color/lut/GBA-LUT.slang"; }
    {
      shader = "handheld/shaders/lcd3x.slang";
      scaleTypeX = "viewport";
      scaleTypeY = "viewport";
    }
    { shader = "handheld/shaders/color/gba-color.slang"; }
    {
      shader = "handheld/shaders/pixel_transparency/pixel_transparency.slang";
      scaleTypeX = "viewport";
      scaleTypeY = "viewport";
    }
  ];
  textures = {
    SamplerLUT1.path = "handheld/shaders/color/lut/gba-grey1.png";
    SamplerLUT2.path = "handheld/shaders/color/lut/gba-grey2.png";
  };
  params = {
    # pixel_transparency
    PT_ACCEL_ENABLE = "0.000000";
  };
}
