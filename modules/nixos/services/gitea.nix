{
  lib,
  config,
  ...
}:
let
  cfg = config.gitea;
  hostName = "${config.networking.hostName}.local";
in
{
  options.gitea = {
    enable = lib.mkEnableOption "Enable my gitea configuration";
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/gitea";
      description = "Path for Gitea application data";
    };
    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port Gitea will listen on (proxied by nginx)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea = {
      enable = true;
      appName = "Gitea";
      user = "gitea";

      settings = {
        server = {
          APP_DATA_PATH = cfg.dataDir;
          HTTP_PORT = cfg.httpPort;
        };
      };
    };

    services.nginx.virtualHosts."gitea.${hostName}" = {
      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.httpPort}";
      locations."/".proxyWebsockets = true;
    };

    services.dnsmasq.settings.address = [ "/gitea.${hostName}/${config.custom.staticIP}" ];

    services.homepage-dashboard.services = lib.mkOrder 300 [
      {
        "Development" = [
          {
            Gitea = {
              icon = "gitea";
              href = "http://gitea.${hostName}";
            };
          }
        ];
      }
    ];
  };
}
