{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs = {
        prismlauncher.enable = lib.mkDefault true;
        retroarch.enable = lib.mkDefault (!pkgs.stdenv.isDarwin);
        vesktop.enable = lib.mkDefault true;
      };
    }
    (lib.mkIf config.programs.retroarch.enable {
      home.file = {
        gameLibrary = {
          target = "game_library/README.md";
          text = ''
            # ~/game_library

            A library directory for games.

          '';
        };
        globalShader = {
          target = ".config/retroarch/config/global.slangp";
          source = pkgs.crt-shader;
        };
        gambatteShader = {
          target = ".config/retroarch/config/Gambatte/Gambatte.slangp";
          source = pkgs.gbc-shader;
        };
        melondsShader = {
          target = ".config/retroarch/config/melonDS/melonDS.slangp";
          source = pkgs.ds-shader;
        };
        mgbaShader = {
          target = ".config/retroarch/config/mGBA/mGBA.slangp";
          source = pkgs.gba-shader;
        };
        ppssppShader = {
          target = ".config/retroarch/config/PPSSPP/PPSSPP.slangp";
          source = pkgs.psp-shader;
        };
      };
      programs = {
        retroarch = {
          cores = {
            gambatte.enable = true;
            genesis-plus-gx.enable = true;
            melonds.enable = true;
            mesen.enable = true;
            mgba.enable = true;
            mupen64plus.enable = true;
            ppsspp.enable = true;
            snes9x.enable = true;
            swanstation.enable = true;
          };
          settings = {
            all_users_control_menu = "true";
            content_show_images = "false";
            content_show_music = "false";
            content_show_netplay = "false";
            content_show_video = "false";
            input_max_users = "4";
            menu_driver = "ozone";
            netplay_nickname = "jtrrll";
            rgui_browser_directory = "${config.home.homeDirectory}/game_library";
            video_driver = "vulkan";
            video_shader_enable = "true";
          };
        };
      };
    })
  ];
}
