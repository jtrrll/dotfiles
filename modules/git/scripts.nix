{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.git.enable {
    programs.git.settings.alias = {
      ezswitch = "!${
        lib.getExe (
          pkgs.writeShellApplication rec {
            meta.mainProgram = name;
            name = "git-ezswitch";
            runtimeInputs = [
              config.programs.git.package
              pkgs.gum
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
        )
      }";
      open = "!${
        lib.getExe (
          pkgs.writeShellApplication rec {
            meta.mainProgram = name;
            name = "git-open";
            runtimeInputs = [
              config.programs.git.package
              pkgs.gnused
            ]
            ++ lib.optional pkgs.stdenv.isLinux pkgs.xdg-utils;
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
              ${if pkgs.stdenv.isLinux then "xdg-open" else "open"} "$browser_url" >/dev/null 2>&1 &
              disown
            '';
          }
        )
      }";
      trim = "!${
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
              base="origin/$main_branch"

              git fetch origin --prune

              merged_branches=$(git branch --merged "$base" --format="%(refname:short)" | grep -v "$main_branch" || true)

              if [[ -z "$merged_branches" ]]; then
                gum style --foreground 2 "✓ No merged branches to delete"
                exit 0
              fi

              gum style --bold "The following branches have been merged into $base:"
              echo "$merged_branches"

              gum confirm "Delete these branches?" || exit 0

              git switch "$main_branch"

              for branch in $merged_branches; do
                git branch -d "$branch"
              done

              git pull
            '';
          }
        )
      }";
    };
  };
}
