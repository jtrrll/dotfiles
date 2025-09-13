{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.git.enable {
    programs.git.aliases.ezswitch = "!${
      lib.getExe (
        pkgs.writeShellApplication rec {
          meta.mainProgram = name;
          name = "git-ezswitch";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.git
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
  };
}
