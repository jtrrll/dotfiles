{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      plugins = {
        barbar = {
          enable = true;
          settings.auto_hide = 1;
        };
        snacks = {
          enable = true;
          settings = {
            explorer.enabled = true;
            picker = {
              enabled = true;
              sources.explorer = {
                auto_close = true;
                hidden = true;
                layout.layout.position = "right";
              };
            };
          };
        };
      };
    };
  };
}
