{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.editors.neovim.enable {
    programs.nixvim.plugins.blink-cmp = {
      enable = true;
      settings = {
        completion.list.max_items = 10;
        fuzzy.implementation = "prefer_rust";
        keymap.preset = "super-tab";
      };
    };
  };
}
