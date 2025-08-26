{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.git.enable {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "git-switch";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.git
          pkgs.gum
        ];
        text = ''
          if [[ "$#" -ne 0 ]]; then
            echo "Usage: $(basename "$0")"
            exit 1
          fi

          branch=$(git branch --format="%(refname:short)" | gum filter)

          git switch "$branch"
        '';
      })
    ];
  };
}
