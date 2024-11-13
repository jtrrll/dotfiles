{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.git.enable {
    home.packages = [
      (pkgs.writeShellApplication
        {
          name = "git-trim";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.git
            pkgs.gnugrep
            pkgs.gum
          ];
          text = ''
            if [[ "$#" -ne 1 ]]; then
              echo "Usage: $(basename "$0") <main-branch>"
              exit 1
            fi
            main_branch="$1"

            gum confirm

            git switch "$main_branch"

            for branch in $(git branch --format="%(refname:short)" | grep -v "$main_branch"); do
                git branch -D "$branch"
            done

            git pull
          '';
        })
    ];
  };
}
