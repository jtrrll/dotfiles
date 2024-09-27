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
        inherit signs;
        signs_staged = signs;
      };
    };
  };
}
