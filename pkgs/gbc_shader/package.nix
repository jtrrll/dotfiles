{ mkSlangShader }:
mkSlangShader {
  name = "gbc_shader";
  description = "A GB and GBC shader that replicates original hardware";
  passes = [
    { shader = "handheld/shaders/color/lut/GBC-LUT.slang"; }
    {
      shader = "handheld/shaders/lcd-cgwg/lcd-grid-v2.slang";
      scaleTypeX = "viewport";
      scaleTypeY = "viewport";
    }
    { shader = "handheld/shaders/color/gbc-color.slang"; }
    {
      shader = "handheld/shaders/pixel_transparency/pixel_transparency.slang";
      scaleTypeX = "viewport";
      scaleTypeY = "viewport";
    }
  ];
  textures = {
    SamplerLUT1.path = "handheld/shaders/color/lut/gbc-grey1.png";
    SamplerLUT2.path = "handheld/shaders/color/lut/gbc-grey2.png";
  };
  params = {
    LUT_selector_param = "2.000000";
    gain = "1.250000";
    gamma = "3.500000";
    blacklevel = "0.000000";
  };
}
