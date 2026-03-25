{
  config,
  lib,
  options,
  ...
}:
{
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

  config = lib.mkMerge [
    { programs.nixvim.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.nixvim.enable {
      home.sessionVariables.EDITOR = lib.getExe config.programs.nixvim.package;
    })
    {
      programs.nixvim = {
        colorschemes.vscode.enable = true;
        plugins.lz-n.enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        plugins.snacks = {
          enable = true;
          settings = {
            bigfile.enabled = true;
            quickfile.enabled = true;
          };
        };
      };
    }
    (lib.mkIf (options ? stylix) { stylix.targets.nixvim.enable = false; })
  ];
}
