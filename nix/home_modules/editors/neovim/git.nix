{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.editors.neovim.enable {
    programs.nixvim.plugins.gitsigns = {
      enable = true;
      settings =
        let
          signs = {
            add.text = "+";
            change.text = "~";
            changedelete.text = "~";
            delete.text = "-";
            topdelete.text = "-";
          };
        in
        {
          inherit signs;
          current_line_blame = true;
          signs_staged = signs;
        };
    };
  };
}
