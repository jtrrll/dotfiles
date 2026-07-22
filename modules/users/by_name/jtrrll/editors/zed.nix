{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.zed-editor.enable = lib.mkDefault true;
    }
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
