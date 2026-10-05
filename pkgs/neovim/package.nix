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
      ./command_display.nix
      ./formatting.nix
      ./theme.nix
      ./vim_options.nix
      {
        extraPackages = with pkgs; [
          lua-language-server
          tree-sitter
        ];
        viAlias = true;
        vimAlias = true;
        plugins.lazy = {
          enable = true;
          settings = {
            defaults.lazy = false;
            checker.enabled = true;
            dev.patterns = lib.mkForce [ ];
          };
          plugins = [
            {
              pkg = pkgs.vimPlugins.LazyVim;
              name = "LazyVim";
              lazy = false;
            }
            { import = "lazyvim.plugins"; }
            # keep-sorted start
            { import = "lazyvim.plugins.extras.dap.core"; }
            { import = "lazyvim.plugins.extras.lang.clangd"; }
            { import = "lazyvim.plugins.extras.lang.cmake"; }
            { import = "lazyvim.plugins.extras.lang.docker"; }
            { import = "lazyvim.plugins.extras.lang.erlang"; }
            { import = "lazyvim.plugins.extras.lang.git"; }
            { import = "lazyvim.plugins.extras.lang.gleam"; }
            { import = "lazyvim.plugins.extras.lang.go"; }
            { import = "lazyvim.plugins.extras.lang.haskell"; }
            { import = "lazyvim.plugins.extras.lang.java"; }
            { import = "lazyvim.plugins.extras.lang.json"; }
            { import = "lazyvim.plugins.extras.lang.lean"; }
            { import = "lazyvim.plugins.extras.lang.markdown"; }
            { import = "lazyvim.plugins.extras.lang.nix"; }
            { import = "lazyvim.plugins.extras.lang.nushell"; }
            { import = "lazyvim.plugins.extras.lang.python"; }
            { import = "lazyvim.plugins.extras.lang.rust"; }
            { import = "lazyvim.plugins.extras.lang.sql"; }
            { import = "lazyvim.plugins.extras.lang.terraform"; }
            { import = "lazyvim.plugins.extras.lang.toml"; }
            { import = "lazyvim.plugins.extras.lang.typescript"; }
            { import = "lazyvim.plugins.extras.lang.typst"; }
            { import = "lazyvim.plugins.extras.lang.yaml"; }
            { import = "lazyvim.plugins.extras.lang.zig"; }
            { import = "lazyvim.plugins.extras.linting.nvim-lint"; }
            { import = "lazyvim.plugins.extras.test.core"; }
            { import = "lazyvim.plugins.extras.util.dot"; }
            # keep-sorted end
            {
              __unkeyed = "folke/snacks.nvim";
              opts.picker.sources.explorer.layout.layout.position = "right";
            }
            {
              __unkeyed = "nvim-lualine/lualine.nvim";
              opts.__raw = ''
                function(_, opts)
                  table.insert(opts.sections.lualine_x, 1, _G.command_statusline)
                  opts.sections.lualine_c[1] = LazyVim.lualine.root_dir({ cwd = true })
                  opts.sections.lualine_z = {}
                  return opts
                end
              '';
            }
            {
              __unkeyed = "mason-org/mason.nvim";
              opts.__raw = ''
                function(_, opts)
                  opts.ensure_installed = {}
                  return opts
                end
              '';
            }
            {
              __unkeyed = "neovim/nvim-lspconfig";
              opts.servers = {
                gdscript = { };
                lua_ls.mason = false;
              };
            }
            {
              __unkeyed = "nvim-treesitter/nvim-treesitter";
              opts.ensure_installed = [ "gdscript" ];
            }
          ];
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
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = "v${neovim.config.package.version}";
      };
    };
  }
)
