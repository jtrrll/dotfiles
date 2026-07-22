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
      stylix.targets.zed.colors.override =
        let
          inherit (config.lib.stylix.colors)
            base08
            base09
            base0A
            base0B
            base0C
            base0D
            ;
        in
        {
          "base03-hex" = base0B; # comment/hint/predictive -> VS Code comment green
          "base04-hex" = base0B; # comment.doc -> VS Code comment green
          "base08-hex" = base0C; # property/variable/tag -> VS Code variable cyan
          "base09-hex" = base0D; # boolean/constant/number/attribute -> VS Code boolean/constant blue
          "base0A-hex" = base0C; # type/namespace/emphasis.strong -> VS Code type teal (#4ec9b0, no exact slot; cyan closest)
          "base0B-hex" = base09; # string/string.special.symbol -> VS Code string orange
          "base0C-hex" = base08; # string.escape/regex/special/enum -> VS Code regex/special salmon (#d16969, no exact slot; red closest)
          "base0D-hex" = base0A; # function/constructor/title -> VS Code function yellow
          "base0E-hex" = base0D; # keyword/emphasis/selector -> VS Code keyword blue
        };
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

        userSettings = {
          agent_servers.OpenCode = {
            command = "opencode";
            args = [ "acp" ];
          };

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
