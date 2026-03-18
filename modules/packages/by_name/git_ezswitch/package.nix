{
  git,
  gum,
  lib,
  writeShellApplication,
}:
writeShellApplication rec {
  meta = {
    inherit (git.meta) platforms;
    description = "Interactively switches git branches";
    license = lib.licenses.agpl3Plus;
    mainProgram = name;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
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
