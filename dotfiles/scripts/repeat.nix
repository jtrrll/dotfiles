{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.scripts.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "repeat" ''
        if [[ "$#" -lt 2 ]]; then
          echo "Usage: $(basename "$0") <interval> <command> [args...]"
          exit 1
        fi

        INTERVAL="$1"
        shift

        ${pkgs.watch}/bin/watch --color -n "$INTERVAL" "$@"
      '')
    ];
  };
}
