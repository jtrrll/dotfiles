{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.zellij.enable = lib.mkDefault true;
    }
    (lib.mkIf config.programs.zellij.enable {
      home.packages = [ pkgs.watch ];
      programs.zellij.plugins = [
        pkgs.zellij-agent-handler
      ];
      programs.zellij.layouts =
        let
          inDevShell =
            command:
            "if nix develop --no-pure-eval -c true 2>/dev/null; then exec nix develop --no-pure-eval -c ${command}; else echo 'failed to load devshell' >&2; exec ${command}; fi";
          withDefaultTabTemplate = tabs: ''
            layout {
              default_tab_template {
                pane size=1 borderless=true {
                  plugin location="zellij:tab-bar"
                }
                children
                pane size=1 borderless=true {
                  plugin location="zellij:status-bar"
                }
              }
            ${tabs}
            }
          '';
        in
        lib.mapAttrs (_: withDefaultTabTemplate) {
          edit = ''
            tab split_direction="vertical" {
              pane name="text editor" command="sh" {
                args "-c" "${inDevShell "$VISUAL"}"
              }
              pane {
                pane name="coding agent" size="60%" command="sh" {
                  args "-c" "${inDevShell "$AGENT_HARNESS"}"
                }
                pane name="git" size="40%" command="lazygit"
              }
            }
          '';
          plan = ''
            tab name="plan" {
              pane name="planning agent" command="sh" {
                args "-c" "exec $AGENT_HARNESS"
              }
            }
          '';
          test = ''
            tab {
              pane size="75%"
              pane name="nix flake check" size="25%" command="nix" {
                args "flake" "check" "--impure"
              }
            }
          '';
        };
      programs.zellij.settings = {
        pane_frame_style = "full";
        show_release_notes = false;
        show_startup_tips = false;
        theme = "ansi";
        ui.pane_frames.rounded_corners = true;
      };
    })
  ];
}
