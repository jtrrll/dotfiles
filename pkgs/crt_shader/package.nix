{ mkSlangShader }:
mkSlangShader {
  name = "crt_shader";
  description = "A CRT shader that blends pixels";
  reference = "crt/newpixie-crt.slangp";
  overrides = {
    blur_x = "0.750000";
    blur_y = "0.750000";
    curvature = "0.000100";
  };
}
