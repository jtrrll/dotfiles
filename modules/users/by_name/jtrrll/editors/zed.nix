{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.zed-editor.enable = lib.mkDefault true;
    }
    (lib.mkIf (options ? stylix) {
      stylix.targets.zed.fonts.override = {
        sizes = {
          terminal = 15;
          applications = 16.5;
        };
      };
      # Disable stylix's generic base16->Zed template (tinted-zed): it
      # reuses base03/base04 across ~20 unrelated chrome roles (muted
      # text, disabled icons, scrollbar thumbs, line numbers, etc.), so
      # remapping them for comment color paints all of that chrome the
      # same color. It also uses base00 (the scheme's darkest gray) for
      # every background role, which is much darker than real VS Code
      # Dark Modern's editor background. A custom theme is defined below
      # instead, giving each role its own independent slot.
      stylix.targets.zed.colors.enable = false;
    })
    (lib.mkIf config.programs.zed-editor.enable {
      fonts.fontconfig.enable = true;
      home = {
        packages = [
          pkgs.ibm-plex
          pkgs.nerd-fonts.hack
        ];
        sessionVariables.VISUAL = lib.getExe config.programs.zed-editor.package;
      };
      programs.zed-editor = {
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
          in
          lib.sort (a: b: a < b) languages;
        extraPackages = [
          # keep-sorted start
          pkgs.netcat # required by GDScript extension
          # keep-sorted end
        ];

        themes."jtrrll custom" = lib.mkIf (options ? stylix) (
          let
            c = config.lib.stylix.colors.withHashtag;
          in
          {
            "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
            name = "jtrrll custom";
            author = "jtrrll";
            themes = [
              {
                name = "jtrrll custom";
                appearance = "dark";
                style = {
                  background = c.base02;
                  "editor.background" = c.base02;
                  "editor.foreground" = c.base05;
                  "editor.gutter.background" = c.base02;
                  "editor.line_number" = c.base03;
                  "editor.active_line_number" = c.base05;
                  "editor.active_line.background" = c.base01;
                  text = c.base05;
                  "text.muted" = c.base04;
                  "text.accent" = c.base0D;
                  "text.placeholder" = c.base03;
                  "text.disabled" = c.base03;
                  border = "${c.base03}66"; # reduced opacity: base03 at full strength reads as a bright outline against the dark background
                  "border.variant" = c.base01;
                  "border.focused" = c.base0D;
                  "border.selected" = "${c.base03}66";
                  "border.disabled" = c.base01;
                  "elevated_surface.background" = c.base01;
                  "surface.background" = c.base01;
                  "panel.background" = c.base01;
                  "status_bar.background" = c.base01;
                  "title_bar.background" = c.base01;
                  "toolbar.background" = c.base02;
                  "tab_bar.background" = c.base01;
                  "tab.active_background" = c.base02;
                  "tab.inactive_background" = c.base01;
                  "scrollbar.thumb.background" = c.base03;
                  "terminal.background" = c.base01;
                  "terminal.foreground" = c.base05;
                  "terminal.ansi.black" = c.base01;
                  "terminal.ansi.bright_black" = c.base03;
                  "terminal.ansi.red" = c.base08;
                  "terminal.ansi.bright_red" = c.base08;
                  "terminal.ansi.green" = c.base0B;
                  "terminal.ansi.bright_green" = c.base0B;
                  "terminal.ansi.yellow" = c.base0A;
                  "terminal.ansi.bright_yellow" = c.base0A;
                  "terminal.ansi.blue" = c.base0D;
                  "terminal.ansi.bright_blue" = c.base0D;
                  "terminal.ansi.magenta" = c.base0E;
                  "terminal.ansi.bright_magenta" = c.base0E;
                  "terminal.ansi.cyan" = c.base0C;
                  "terminal.ansi.bright_cyan" = c.base0C;
                  "terminal.ansi.white" = c.base05;
                  "terminal.ansi.bright_white" = c.base07;
                  error = c.base08;
                  warning = c.base0A;
                  info = c.base0D;
                  # `hint` doubles as the git-blame inline text color in
                  # Zed's own git_ui crate (blame_ui.rs uses
                  # cx.theme().status().hint for the muted blame label,
                  # not text_muted), so keep it a neutral gray here rather
                  # than an accent color, even though it's semantically
                  # "diagnostic hint" everywhere else.
                  hint = c.base04;
                  "version_control.added" = c.base0B;
                  "version_control.modified" = c.base0A;
                  "version_control.deleted" = c.base08;
                  # Only the local player (index 0) is overridden; Zed
                  # ignores this list entirely (keeping its own built-in
                  # 8-color palette) if it's empty, so there's no need to
                  # restate the collaborator colors just to change our own
                  # cursor. See merge_player_colors in
                  # crates/theme_settings/src/theme_settings.rs.
                  players = [
                    {
                      cursor = c.base05; # local cursor: text color/white
                      background = null;
                      selection = "${c.base05}33";
                    }
                  ];
                  syntax = {
                    comment = {
                      color = c.base0B;
                    };
                    "comment.doc" = {
                      color = c.base0B;
                    };
                    string = {
                      color = c.base09;
                    };
                    "string.escape" = {
                      color = c.base08;
                    };
                    "string.regex" = {
                      color = c.base08;
                    };
                    "string.special" = {
                      color = c.base08;
                    };
                    "string.special.symbol" = {
                      color = c.base09;
                    };
                    number = {
                      color = c.base0D;
                    };
                    boolean = {
                      color = c.base0D;
                    };
                    constant = {
                      color = c.base0D;
                    };
                    variable = {
                      color = c.base0C;
                    };
                    property = {
                      color = c.base0C;
                    };
                    attribute = {
                      color = c.base0C;
                    };
                    tag = {
                      color = c.base0D;
                    };
                    keyword = {
                      color = c.base0D;
                    };
                    "keyword.control" = {
                      color = c.base0E;
                    };
                    "keyword.import" = {
                      color = c.base0E;
                    };
                    function = {
                      color = c.base0A;
                    };
                    constructor = {
                      color = c.base0D;
                    };
                    type = {
                      color = c.base0C;
                    };
                    "type.builtin" = {
                      color = c.base0D;
                    };
                    operator = {
                      color = c.base05;
                    };
                    punctuation = {
                      color = c.base05;
                    };
                    "punctuation.bracket" = {
                      color = c.base05;
                    };
                    "punctuation.delimiter" = {
                      color = c.base05;
                    };
                  };
                };
              }
            ];
          }
        );

        userSettings = {
          agent_servers.OpenCode = {
            command = "opencode";
            args = [ "acp" ];
          };

          theme = lib.mkIf (options ? stylix) "jtrrll custom";

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
          tab_size = 2;
          wrap_guides = [
            100
            120
          ];
          vertical_scroll_margin = 8;
          vim_mode = true;

          buffer_font_features.calt = false; # Disable ligatures
        };
      };
    })
  ];
}
