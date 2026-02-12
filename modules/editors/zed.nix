{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.editors;
in
{
  config = lib.mkIf cfg.zed.enable (
    lib.mkMerge [
      {
        programs.zed-editor = {
          enable = true;

          mutableUserDebug = false;
          mutableUserKeymaps = false;
          mutableUserSettings = false;
          mutableUserTasks = false;

          extensions =
            let
              languages = [
                # keep-sorted start
                "bash"
                "graphql"
                "haskell"
                "html"
                "java"
                "lua"
                "nix"
                "nu"
                "ruby"
                "sorbet"
                "svelte"
                "templ"
                "terraform"
                "toml"
                "typst"
                "zed-gdscript"
                "zed-gleam"
                "zed-groovy"
                "zig"
                # keep-sorted end
              ];
              ui = [
                # keep-sorted start
                "vscode-dark-modern"
                # keep-sorted end
              ];
            in
            lib.sort (a: b: a < b) languages ++ ui;
          extraPackages = [
            # keep-sorted start
            pkgs.netcat # required by GDScript extension
            # keep-sorted end
          ];

          userSettings = {
            file_scan_exclusions = [
              # keep-sorted start
              "**/*_templ.go"
              "**/.DS_Store"
              "**/.classpath"
              "**/.devenv"
              "**/.direnv"
              "**/.git"
              "**/.hg"
              "**/.jj"
              "**/.pre-commit-config.yaml"
              "**/.settings"
              "**/.svn"
              "**/CVS"
              "**/Thumbs.db"
              "**/node_modules"
              # keep-sorted end
            ];

            languages = {
              Ruby.language_servers = [
                "ruby-lsp"
                "sorbet"
                "rubocop"
                "!solargraph"
                "..."
              ];
            };

            collaboration_panel = {
              button = false;
              dock = "right";
            };
            git_panel.dock = "right";
            outline_panel.dock = "right";
            project_panel.dock = "right";

            relative_line_numbers = "enabled";
            tab_size = cfg.indentWidth;
            wrap_guides = cfg.lineLengthRulers;
            vertical_scroll_margin = cfg.linesAroundCursor;
            vim_mode = true;

            theme = "VSCode Dark Modern";
            buffer_font_family = "Hack Nerd Font Mono";
            buffer_font_features.calt = false; # Disable ligatures
            buffer_font_size = 20;
            ui_font_family = "IBM Plex Sans";
            ui_font_size = 22;
          };
        };
      }
      (lib.optionalAttrs (options ? stylix) { stylix.targets.zed.enable = false; })
    ]
  );
}
