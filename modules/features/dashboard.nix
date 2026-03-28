{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.glance =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.glance;
      settingsFormat = pkgs.formats.yaml { };
      settingsFile = settingsFormat.generate "glance.yml" cfg.settings;
      configFilePath = "${config.xdg.configHome}/glance/glance.yml";
    in
    {
      disabledModules = [ "services/glance.nix" ];

      options.services.glance = {
        enable = lib.mkEnableOption "glance";
        package = lib.mkPackageOption pkgs "glance" { };
        settings = lib.mkOption {
          inherit (settingsFormat) type;
          default = { };
          description = ''
            Configuration written to a yaml file that is read by glance. See
            <https://github.com/glanceapp/glance/blob/main/docs/configuration.md>
            for more.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
        xdg.configFile."glance/glance.yml".source = settingsFile;

        launchd.agents.glance = lib.mkIf (cfg.package != null && pkgs.stdenv.isDarwin) {
          enable = true;
          config = {
            Label = "glance";
            ProgramArguments = [
              (lib.getExe cfg.package)
              "--config"
              configFilePath
            ];
            RunAtLoad = true;
            KeepAlive = true;
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/glance.err";
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/glance.log";
          };
        };

        systemd.user.services.glance = lib.mkIf (cfg.package != null && pkgs.stdenv.isLinux) {
          Unit = {
            Description = "Glance feed dashboard server";
            PartOf = [ "graphical-session.target" ];
            X-Restart-Triggers = [
              settingsFile
            ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service.ExecStart = "${lib.getExe cfg.package} --config ${configFilePath}";
        };
      };
    };
}
