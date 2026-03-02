{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config = {
    flake.modules = {
      homeManager.dotfiles =
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
                  source = self.packages.${pkgs.stdenv.hostPlatform.system}.crtShader;
                };
                gambatteShader = {
                  target = ".config/retroarch/config/Gambatte/Gambatte.slangp";
                  source = self.packages.${pkgs.stdenv.hostPlatform.system}.gbcShader;
                };
                melondsShader = {
                  target = ".config/retroarch/config/melonDS/melonDS.slangp";
                  source = self.packages.${pkgs.stdenv.hostPlatform.system}.dsShader;
                };
                mgbaShader = {
                  target = ".config/retroarch/config/mGBA/mGBA.slangp";
                  source = self.packages.${pkgs.stdenv.hostPlatform.system}.gbaShader;
                };
                ppssppShader = {
                  target = ".config/retroarch/config/PPSSPP/PPSSPP.slangp";
                  source = self.packages.${pkgs.stdenv.hostPlatform.system}.pspShader;
                };
              };
              programs = {
                retroarch = {
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
              };
            })
          ];
        };
      nixos.gaming =
        { config, lib, ... }:
        let
          cfg = config.dotfiles.gaming;
        in
        {
          options.dotfiles.gaming = {
            enable = lib.mkEnableOption "jtrrll's gaming configuration";
          };

          config.programs.steam = lib.mkIf cfg.enable {
            enable = true;
            remotePlay.openFirewall = true;
          };
        };
    };

    perSystem =
      { pkgs, ... }:
      {
        config.packages = {
          crtShader = pkgs.callPackage ./shaders/crt.nix { };
          dsShader = pkgs.callPackage ./shaders/ds.nix { };
          gbaShader = pkgs.callPackage ./shaders/gba.nix { };
          gbcShader = pkgs.callPackage ./shaders/gbc.nix { };
          pspShader = pkgs.callPackage ./shaders/psp.nix { };
        };
      };
  };
}
