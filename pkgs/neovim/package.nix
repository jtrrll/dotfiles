{
  lib,
  pkgs,
  testers,
}:
let
  neovim = lib.nixvim.evalNixvim {
    modules = [
      {
        nixpkgs.pkgs = pkgs;
        version.enableNixpkgsReleaseCheck = false;
      }
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
      {
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
      }
    ];
  };
in
neovim.config.build.package.overrideAttrs (
  finalAttrs: previousAttrs: {
    meta = previousAttrs.meta // {
      description = "Personalized Neovim distribution built with Nixvim";
      platforms = lib.platforms.unix;
      sourceProvenance = [ lib.sourceTypes.fromSource ];
    };
    passthru.tests = {
      nixvim-check = neovim.config.build.test;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = "v${neovim.config.package.version}";
      };
    };
  }
)
