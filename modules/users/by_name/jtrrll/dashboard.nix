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
                size = "full";
                widgets = [
                  { type = "calendar"; }
                  {
                    type = "weather";
                    location = "Boston, Massachusetts, United States";
                  }
                ];
              }
            ];
          }
        ];
      };
    })
  ];
}
