{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.scripts.repeat.enable {
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

  options = {
    dotfiles.scripts.repeat = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable the 'repeat' script.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
