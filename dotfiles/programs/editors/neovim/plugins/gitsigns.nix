{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
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
