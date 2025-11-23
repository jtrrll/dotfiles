{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.git.enable {
    programs.git.settings.alias.trim = "!${
      lib.getExe (
        pkgs.writeShellApplication rec {
          meta.mainProgram = name;
          name = "git-trim";
          runtimeInputs = [
            config.programs.git.package
            pkgs.gnugrep
            pkgs.gum
            pkgs.uutils-coreutils-noprefix
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
        }
      )
    }";
  };
}
