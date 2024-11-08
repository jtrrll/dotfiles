{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.screensavers.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "bonsai" ''
        if [[ "$#" -ne 0 ]]; then
          echo "Usage: $(basename "$0")"
          exit 1
        fi

        sleep .25
        ${pkgs.cbonsai}/bin/cbonsai \
          --base 2 \
          --infinite \
          --live \
          --seed "$RANDOM" \
          --time 0.7
      '')
    ];
  };
}
