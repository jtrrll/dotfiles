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
                      <ul class="list list-gap-14">
                        {{ range .JSON.Array "" }}
                          <li>
                            <div class="flex justify-between">
                              <strong>{{ .String "name" }}</strong>
                              {{ if eq (.String "state") "running" }}
                                <span class="color-positive">● running</span>
                              {{ else if eq (.String "state") "idle" }}
                                <span class="color-subtext">○ idle</span>
                              {{ else if eq (.String "state") "error" }}
                                <span class="color-negative">✕ error</span>
                              {{ else }}
                                <span class="color-subtext">? {{ .String "state" }}</span>
                              {{ end }}
                            </div>
                            <div class="flex justify-between margin-top-3">
                              {{ if .String "detail" }}
                                <span class="size-h6 color-subtext">{{ .String "detail" }}</span>
                              {{ end }}
                              {{ if .String "kind" }}
                                <span class="size-h6 color-subtext">{{ .String "kind" }}</span>
                              {{ end }}
                              {{ if .String "schedule" }}
                                <span class="size-h6 color-subtext">⏱ {{ .String "schedule" }}</span>
                              {{ end }}
                            </div>
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
                      <ul class="list list-gap-4">
                        {{ range sortByInt "port" "asc" (.JSON.Array "") }}
                          <li class="flex justify-between">
                            <span class="color-highlight size-h4">:{{ .Int "port" }}</span>
                            <span>{{ .String "process" }}</span>
                            <span class="color-subtext">pid {{ .String "pid" }}</span>
                            <span class="color-subtext">{{ .String "address" }}</span>
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
