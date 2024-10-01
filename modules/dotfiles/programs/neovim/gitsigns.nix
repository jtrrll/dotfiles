{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins.gitsigns = {
      enable = true;
      settings = let
        signs = {
          add.text = "+";
          change.text = "~";
          changedelete.text = "~";
          delete.text = "-";
          topdelete.text = "-";
        };
      in {
        current_line_blame = true;
        current_line_blame_opts.virt_text_priority = 5000; # Display blame after diagnostics
        inherit signs;
        signs_staged = signs;
      };
    };
  };
}
