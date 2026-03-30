{ config, lib, ... }:
{
  config = lib.mkMerge [
    { services.glance.enable = lib.mkDefault true; }
    (lib.mkIf config.services.glance.enable {
      services.glance.settings = {
        server.port = 5678;
        pages = [
          {
            name = "Home";
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "weather";
                    location = "Boston, Massachusetts, United States";
                    show-area-name = true;
                    units = "imperial";
                  }
                  {
                    type = "server-stats";
                    servers = [
                      { type = "local"; }
                    ];
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "group";
                    widgets = [
                      {
                        type = "hacker-news";
                        collapse-after = -1;
                        limit = 10;
                      }
                      {
                        type = "reddit";
                        subreddit = "NixOS";
                        collapse-after = -1;
                        limit = 10;
                      }
                    ];
                  }
                ];
              }
              {
                size = "small";
                widgets = [
                  { type = "to-do"; }
                ];
              }
            ];
          }
        ];
      };
    })
  ];
}
