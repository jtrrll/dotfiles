{ mkSlangShader }:
mkSlangShader {
  name = "gba_shader";
  description = "A GBA shader that replicates original hardware";
  passes = [
    { shader = "handheld/shaders/color/lut/GBA-LUT.slang"; }
    {
      shader = "handheld/shaders/lcd-cgwg/lcd-grid-v2.slang";
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
    gamma = "3.500000";
    blacklevel = "0.000000";
    BGR = "1.000000";
  };
}
