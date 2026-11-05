{
  config,
  lib,
  pkgs,
  ...
}:
let
  diffnav = pkgs.diffnav.override { delta = config.programs.delta.finalPackage; };
in
{
  config = lib.mkMerge [
    { programs.git.enable = lib.mkDefault true; }
    { programs.gh.enable = lib.mkDefault true; }
    { programs.gh-dash.enable = lib.mkDefault true; }
    { programs.lazygit.enable = lib.mkDefault true; }
    {
      programs.delta = {
        enable = lib.mkDefault true;
        options = {
          line-numbers = true;
          syntax-theme = "Visual Studio Dark+";
        };
      };
    }
    (lib.mkIf config.programs.gh-dash.enable {
      programs.gh.extensions = [ pkgs.gh-enhance ];
      programs.gh-dash.settings.keybindings.prs = [
        {
          key = "T";
          name = "enhance";
          command = "${lib.getExe pkgs.gh-enhance} -R {{.RepoName}} {{.PrNumber}}";
        }
      ];
    })
    (lib.mkIf (config.programs.git.enable || config.programs.gh-dash.enable) {
      home.packages = [ diffnav ];
    })
    (lib.mkIf config.programs.gh-dash.enable {
      programs.gh-dash.settings.pager.diff = lib.getExe diffnav;
    })
    (lib.mkIf config.programs.git.enable {
      programs.git = {
        signing.format = null;
        settings = {
          alias = {
            ezswitch = "!${
              lib.getExe (
                pkgs.git-ezswitch.override {
                  git = config.programs.git.package;
                }
              )
            }";
            open = "!${
              lib.getExe (
                pkgs.git-open.override {
                  git = config.programs.git.package;
                }
              )
            }";
            trim = "!${
              lib.getExe (
                pkgs.git-trim.override {
                  git = config.programs.git.package;
                }
              )
            }";
          };
          branch.sort = "-committerdate";
          pager.diff = lib.getExe diffnav;
          diff.algorithm = "histogram";
          fetch.prune = true;
          trailer = {
            cve = {
              key = "Fixes CVE: ";
              cmd = lib.toString (
                pkgs.writeShellScript "git-trailer-cve" ''
                  printf 'https://www.cve.org/CVERecord?id=%s' "$1"
                ''
              );
            };
            issue = {
              key = "Closes: ";
              cmd = lib.toString (
                pkgs.writeShellScript "git-trailer-issue" ''
                  set -eu
                  num="''${1#\#}"
                  url="$(${lib.getExe config.programs.git.package} remote get-url origin 2>/dev/null || true)"
                  # Normalize scp-style and ssh/https URLs to a web base.
                  url="''${url%.git}"
                  case "$url" in
                    git@*:*) host="''${url#git@}"; host="''${host%%:*}"; path="''${url#*:}"; url="https://$host/$path" ;;
                    ssh://*) rest="''${url#ssh://}"; rest="''${rest#*@}"; host="''${rest%%/*}"; path="''${rest#*/}"; url="https://$host/$path" ;;
                  esac
                  if [ -n "$url" ]; then
                    printf '%s/issues/%s' "$url" "$num"
                  else
                    printf '#%s' "$num"
                  fi
                ''
              );
            };
          };
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          tag.sort = "version:refname";
          url."git@github.com:".insteadOf = "https://github.com/";
          user.useConfigOnly = true; # require an email to be defined in local .gitconfig
        };
      };
    })
  ];
}
