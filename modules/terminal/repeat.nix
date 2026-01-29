{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.repeat.enable {
    home.packages = [
      (pkgs.writeShellApplication rec {
        meta.mainProgram = name;
        name = "repeat";
        runtimeInputs = [
          pkgs.bashInteractive
          pkgs.uutils-coreutils-noprefix
          pkgs.watch
        ];
        text = ''
          if [[ "$#" -lt 2 ]]; then
            echo "Usage: $(basename "$0") <interval> <command> [args...]"
            exit 1
          fi
          interval="$1"
          shift

          watch --color --no-title \
            --interval "$interval" \
            --exec bash -ic "$* || true"
        '';
      })
    ];
  };

  options.dotfiles.repeat = {
    enable = lib.mkEnableOption "the repeat script";
  };
}
