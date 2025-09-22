{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.screensavers.enable {
    home.packages = [
      (pkgs.writeShellApplication rec {
        meta.mainProgram = name;
        name = "matrix";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.neo
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
      })
    ];
  };
}
