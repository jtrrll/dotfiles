{ lib, nixvim }:
lib.addMetaAttrs
  {
    description = "Personalized Neovim distribution built with Nixvim";
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  }
  (
    nixvim.makeNixvimWithModule {
      module = {
        imports = [
          ./_clipboard.nix
          ./_code_tree.nix
          ./_completion.nix
          ./_files.nix
          ./_git.nix
          ./_keymaps.nix
          ./_lsp.nix
          ./_save.nix
          ./_status_line.nix
          ./_vim_options.nix
        ];

        colorschemes.vscode.enable = true;
        plugins.lz-n.enable = true;
        viAlias = true;
        vimAlias = true;
        plugins.snacks = {
          enable = true;
          settings = {
            bigfile.enabled = true;
            quickfile.enabled = true;
          };
        };
      };
    }
  )
