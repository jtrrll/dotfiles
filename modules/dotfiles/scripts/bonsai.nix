{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.scripts.repeat.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "bonsai" ''
        if [[ "$#" -ne 0 ]]; then
          echo "Usage: $(basename "$0")"
          exit 1
        fi


        ${pkgs.cbonsai}/bin/cbonsai \
          --base=2 \
          --screensaver \
          --time=0.7
      '')
    ];
  };

  options = {
    dotfiles.scripts.bonsai = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable the 'bonsai' script.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
