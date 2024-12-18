{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.plugins = {
      blink-cmp = {
        enable = true;
        settings = {
          fuzzy.max_items = 10;
          keymap = {
            "<Down>" = [
              "select_next"
              "fallback"
            ];
            "<Tab>" = [
              "select_and_accept"
              "fallback"
            ];
            "<Up>" = [
              "select_prev"
              "fallback"
            ];
          };
        };
      };
      nvim-autopairs.enable = true;
    };
  };
}
