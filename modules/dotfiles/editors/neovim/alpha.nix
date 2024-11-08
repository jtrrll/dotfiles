{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.plugins.alpha = {
      enable = true;
      layout = [
        {
          type = "padding";
          val = 8;
        }
        {
          opts = {
            hl = "Type";
            position = "center";
          };
          type = "text";
          val = [
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];
        }
        {
          type = "padding";
          val = 8;
        }
        {
          opts = {
            hl = "Keyword";
            position = "center";
          };
          type = "text";
          val = config.lib.nixvim.mkRaw ''
            function()
              local hour = tonumber(vim.fn.strftime('%H'))
              -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
              local time_chunk = math.floor((hour + 4) / 8) + 1
              local time_of_day = ({ 'evening', 'morning', 'afternoon', 'evening' })[time_chunk]
              local username = vim.loop.os_get_passwd()['username'] or 'USERNAME'

              return ('Good %s, %s'):format(time_of_day, username)
            end
          '';
        }
      ];
    };
  };
}
