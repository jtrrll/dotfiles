{ config, lib, ... }:
{
  config = lib.mkMerge [
    { services.glance.enable = lib.mkDefault true; }
    (lib.mkIf config.services.glance.enable {
      services.serviceStatus.enable = lib.mkDefault true;
      services.glance.settings =
        let
          serviceStatusUrl = "http://127.0.0.1:${builtins.toString config.services.serviceStatus.port}";
        in
        {
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
          ]
          ++ lib.optional config.services.serviceStatus.enable {
            name = "System";
            columns = [
              {
                size = "full";
                widgets = [
                  {
                    type = "custom-api";
                    title = "Services";
                    cache = "30s";
                    url = "${serviceStatusUrl}/status";
                    template = ''
                      <ul class="list list-gap-14 list-with-separator">
                        {{ range .JSON.Array "" }}
                          <li>
                            <span class="size-h3 color-highlight">{{ .String "name" }}</span>
                            <ul class="list-horizontal-text">
                              {{ if eq (.String "state") "running" }}
                                <li class="color-positive">● running</li>
                              {{ else if eq (.String "state") "idle" }}
                                <li>○ idle</li>
                              {{ else if eq (.String "state") "error" }}
                                <li class="color-negative">✕ error</li>
                              {{ else }}
                                <li>? {{ .String "state" }}</li>
                              {{ end }}
                              {{ if .String "detail" }}<li>{{ .String "detail" }}</li>{{ end }}
                              {{ if .String "kind" }}<li>{{ .String "kind" }}</li>{{ end }}
                              {{ if .String "schedule" }}<li>{{ .String "schedule" }}</li>{{ end }}
                            </ul>
                          </li>
                        {{ end }}
                      </ul>
                    '';
                  }
                ];
              }
              {
                size = "small";
                widgets = [
                  {
                    type = "custom-api";
                    title = "Listening Ports";
                    cache = "10s";
                    url = "${serviceStatusUrl}/ports";
                    template = ''
                      <ul class="list list-gap-10 list-with-separator">
                        {{ range .JSON.Array "" }}
                          <li>
                            <span class="size-h3 color-highlight">:{{ .Int "port" }}</span>
                            <ul class="list-horizontal-text">
                              <li>{{ .String "process" }}</li>
                              <li>pid {{ .String "pid" }}</li>
                            </ul>
                          </li>
                        {{ end }}
                      </ul>
                    '';
                  }
                ];
              }
            ];
          };
        };
    })
  ];
}
