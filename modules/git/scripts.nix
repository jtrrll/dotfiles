{
  config.perSystem =
    { lib, pkgs, ... }:
    {
      packages = {
        gitEzSwitch = pkgs.callPackage (
          {
            git,
            gum,
            lib,
            writeShellApplication,
          }:
          writeShellApplication rec {
            meta = {
              description = "Interactively switches git branches";
              license = lib.licenses.mit;
              mainProgram = name;
            };
            name = "git-ezswitch";
            runtimeInputs = [
              git
              gum
            ];
            text = ''
              if [[ "$#" -eq 0 ]]; then
                branch=$(git branch --format="%(refname:short)" | gum filter)
                git switch "$branch"
              else
                git switch "$@"
              fi
            '';
          }
        ) { };
        gitOpen = pkgs.callPackage (
          {
            git,
            gnused,
            stdenv,
            writeShellApplication,
            xdg-utils,
          }:
          writeShellApplication rec {
            meta = {
              description = "Opens the upstream git repository in a browser";
              license = lib.licenses.mit;
              mainProgram = name;
            };
            name = "git-open";
            runtimeInputs = [
              git
              gnused
            ]
            ++ lib.optional stdenv.isLinux xdg-utils;
            text = ''
              remote_url=$(git remote get-url origin 2>/dev/null)

              if [[ -z "$remote_url" ]]; then
                echo "No remote repository found"
                exit 1
              fi

              if [[ "$remote_url" =~ ^git@ ]]; then
                browser_url=$(echo "$remote_url" | sed -E 's|^git@([^:]+):(.+)\.git$|https://\1/\2|')
              elif [[ "$remote_url" =~ ^https?:// ]]; then
                browser_url=''${remote_url%.git}
              else
                echo "Unsupported remote URL format: $remote_url"
                exit 1
              fi

              echo "Opening: $browser_url"
              ${if stdenv.isLinux then "xdg-open" else "open"} "$browser_url" >/dev/null 2>&1 &
              disown
            '';
          }
        ) { };
        gitTrim = pkgs.callPackage (
          {
            git,
            gnugrep,
            gum,
            uutils-coreutils-noprefix,
            writeShellApplication,
          }:
          writeShellApplication rec {
            meta = {
              description = "Deletes all working git branches and updates main branch";
              license = lib.licenses.mit;
              mainProgram = name;
            };
            name = "git-trim";
            runtimeInputs = [
              git
              gnugrep
              gum
              uutils-coreutils-noprefix
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
        ) { };
      };
    };
}
