{
  git,
  gnused,
  lib,
  stdenv,
  writeShellApplication,
  xdg-utils,
}:
writeShellApplication rec {
  meta = {
    inherit (git.meta) platforms;
    description = "Opens the upstream git repository in a browser";
    mainProgram = name;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
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
