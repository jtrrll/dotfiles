{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config = {
    flake.modules.homeManager.terminal =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.dotfiles.screensavers;
      in
      {
        options.dotfiles.screensavers = {
          enable = lib.mkEnableOption "jtrrll's screensavers";
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            self.packages.${pkgs.stdenv.hostPlatform.system}.bonsai
            self.packages.${pkgs.stdenv.hostPlatform.system}.matrix
          ];
        };
      };
    perSystem =
      { pkgs, ... }:
      {
        packages = {
          bonsai = pkgs.callPackage (
            {
              cbonsai,
              uutils-coreutils-noprefix,
              writeShellApplication,
            }:
            writeShellApplication rec {
              meta.mainProgram = name;
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
              meta.mainProgram = name;
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
