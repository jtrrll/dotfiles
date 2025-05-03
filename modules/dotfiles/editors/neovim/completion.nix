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
          completion.list.max_items = 15;
          fuzzy.implementation = "prefer_rust";
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
          sources = {
            default = ["lsp" "path" "snippets" "buffer" "copilot"];
            providers = {
              copilot = {
                async = true;
                module = "blink-copilot";
                name = "copilot";
                score_offset = -1;
              };
            };
          };
        };
      };
      blink-copilot.enable = true;
    };
  };
}
