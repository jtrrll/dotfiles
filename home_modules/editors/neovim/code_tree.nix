{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.editors.neovim.enable {
    programs.nixvim.plugins = {
      dropbar.enable = true;
      rainbow-delimiters = {
        enable = true;
        settings.highlight = [
          "RainbowDelimiterYellow"
          "RainbowDelimiterRed"
          "RainbowDelimiterBlue"
        ];
      };
      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
            additional_vim_regex_highlighting = [ "ruby" ];
          };
          indent = {
            enable = true;
            disable = [ "ruby" ];
          };
        };
      };
    };
  };
}
