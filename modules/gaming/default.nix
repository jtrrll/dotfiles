{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.gaming =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      filterAvailable =
        system: pkgsList:
        lib.filter (pkg: (builtins.tryEval (lib.meta.availableOn system pkg)).value) pkgsList;
    in
    {
      config = lib.mkIf config.dotfiles.gaming.enable {
        home = {
          file = {
            gameLibrary = {
              target = "game_library/README.md";
              text = ''
                # ~/game_library

                A library directory for games.

              '';
            };
            globalShader = {
              target = ".config/retroarch/config/global.slangp";
              source = pkgs.callPackage ./shaders/crt.nix { };
            };
            gambatteShader = {
              target = ".config/retroarch/config/Gambatte/Gambatte.slangp";
              source = pkgs.callPackage ./shaders/gbc.nix { };
            };
            melondsShader = {
              target = ".config/retroarch/config/melonDS/melonDS.slangp";
              source = pkgs.callPackage ./shaders/ds.nix { };
            };
            mgbaShader = {
              target = ".config/retroarch/config/mGBA/mGBA.slangp";
              source = pkgs.callPackage ./shaders/gba.nix { };
            };
            ppssppShader = {
              target = ".config/retroarch/config/PPSSPP/PPSSPP.slangp";
              source = pkgs.callPackage ./shaders/psp.nix { };
            };
          };
          packages = filterAvailable pkgs.stdenv.hostPlatform.system [
            pkgs.steam-rom-manager
          ];
        };
        programs = {
          prismlauncher.enable = true;
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
          vesktop.enable = true;
        };
      };

      options.dotfiles.gaming = {
        enable = lib.mkEnableOption "jtrrll's gaming configuration";
      };
    };
}
