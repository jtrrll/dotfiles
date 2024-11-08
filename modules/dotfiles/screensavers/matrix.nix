{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.screensavers.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "matrix" ''
        if [[ "$#" -ne 0 ]]; then
          echo "Usage: $(basename "$0")"
          exit 1
        fi

        ${pkgs.neo}/bin/neo \
          --async \
          --color green3 \
          --colormode 16 \
          --defaultbg \
          --fps 10 \
          --lingerms 1,1000 \
          --maxdpc 1
      '')
    ];
  };
}