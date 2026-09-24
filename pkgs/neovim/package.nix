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
              opts.servers.lua_ls.mason = false;
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
