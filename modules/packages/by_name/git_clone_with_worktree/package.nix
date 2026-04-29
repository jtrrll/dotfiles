{
  git,
  lib,
  writeShellApplication,
}:
writeShellApplication rec {
  meta = {
    inherit (git.meta) platforms;
    description = "Clones a bare git repo and creates a worktree for the default branch";
    mainProgram = name;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
  name = "git-clone-with-worktree";
  runtimeInputs = [
    git
  ];
  text = ''
    if [ $# -lt 3 ]; then
      printf "Usage: git-clone-with-worktree <url> <bare-dest> <worktree-dest>\n" >&2
      exit 1
    fi

    url="$1"
    bare_dest="$2"
    worktree_dest="$3"

    git clone --bare "$url" "$bare_dest"
    git -C "$bare_dest" worktree add "$worktree_dest"
  '';
}
