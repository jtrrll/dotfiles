{ lib' }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.gaming.enable {
    home = {
      file = {
        gameLibrary = {
          target = "game_library/README.md";
          text = ''
            # ~/game_library

            A library directory for games.

          '';
        };
        retroarchGlobalShader = {
          target = ".config/retroarch/config/global.slangp";
          text = ''
            #reference "../shaders/shaders_slang/crt/newpixie-crt.slangp"
            blur_x = "0.750000"
            blur_y = "0.750000"
            curvature = "0.000100"
          '';
        };
      };
      packages = lib'.filterAvailable pkgs.stdenv.system [
        pkgs.prismlauncher
        pkgs.steam-rom-manager
      ];
    };
    programs = {
      retroarch = {
        enable = !pkgs.stdenv.isDarwin;
        cores = {
          fbneo.enable = true;
          gambatte.enable = true;
          genesis-plus-gx.enable = true;
          melonds.enable = true;
          mesen.enable = true;
          mgba.enable = true;
          mupen64plus.enable = true;
          snes9x.enable = true;
          swanstation.enable = true;
        };
        settings = {
          netplay_nickname = "jtrrll";
          rgui_browser_directory = "${config.home.homeDirectory}/game_library";
          video_driver = "vulkan";
          video_shader_enable = "true";
        };
      };
      vesktop.enable = true;
    };
  };

  options.jtrrllDotfiles.gaming = {
    enable = lib.mkEnableOption "jtrrll's gaming configuration";
  };
}
