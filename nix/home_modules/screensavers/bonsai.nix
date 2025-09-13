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
        name = "bonsai";
        runtimeInputs = [
          pkgs.cbonsai
          pkgs.coreutils
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
      })
    ];
  };
}
