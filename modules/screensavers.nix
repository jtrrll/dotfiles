{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config = {
    flake.modules.homeManager = {
      bonsai =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.programs.bonsai;
        in
        {
          options.programs.bonsai = {
            enable = lib.mkEnableOption "a bonsai tree screensaver";
          };

          config = lib.mkIf cfg.enable {
            home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.bonsai ];
          };
        };
      matrix =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.programs.matrix;
        in
        {
          options.programs.matrix = {
            enable = lib.mkEnableOption "a matrix rain screensaver";
          };

          config = lib.mkIf cfg.enable {
            home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.matrix ];
          };
        };
      dotfiles =
        { lib, ... }:
        {
          config.programs = {
            bonsai.enable = lib.mkDefault true;
            matrix.enable = lib.mkDefault true;
          };
        };
    };
    perSystem =
      { pkgs, ... }:
      {
        config.packages = {
          bonsai = pkgs.callPackage (
            {
              cbonsai,
              lib,
              uutils-coreutils-noprefix,
              writeShellApplication,
            }:
            writeShellApplication rec {
              meta = {
                description = "A botanical terminal screensaver";
                license = lib.last cbonsai.meta.license;
                mainProgram = name;
              };
              name = "bonsai";
              runtimeInputs = [
                cbonsai
                uutils-coreutils-noprefix
              ];
              text = ''
                if [[ "$#" -ne 0 ]]; then
                  echo "Usage: $(basename "$0")"
                  exit 1
                fi

                sleep .25
                cbonsai \
                  --base 2 \
                  --infinite \
                  --live \
                  --seed "$RANDOM" \
                  --time 0.7
              '';
            }
          ) { };
          matrix = pkgs.callPackage (
            {
              neo,
              uutils-coreutils-noprefix,
              writeShellApplication,
            }:
            writeShellApplication rec {
              meta = {
                inherit (neo.meta) license;
                description = "A cyberpunk terminal screensaver";
                mainProgram = name;
              };
              name = "matrix";
              runtimeInputs = [
                neo
                uutils-coreutils-noprefix
              ];
              text = ''
                if [[ "$#" -ne 0 ]]; then
                  echo "Usage: $(basename "$0")"
                  exit 1
                fi

                neo \
                  --async \
                  --color green3 \
                  --colormode 16 \
                  --defaultbg \
                  --fps 10 \
                  --lingerms 1,1000 \
                  --maxdpc 1
              '';
            }
          ) { };
        };
      };
  };
}
