{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.immich;
  hostName = "${config.networking.hostName}.local";
in
{
  options.immich = {
    enable = lib.mkEnableOption "Enable immich";
    mediaLocation = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/immich";
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      mediaLocation = cfg.mediaLocation;
      database.enable = true;
      database.enableVectorChord = true;
      redis.enable = true;
      machine-learning.enable = true;
    };

    services.nginx.virtualHosts."immich.${hostName}" = {
      locations."/".proxyPass = "http://127.0.0.1:2283";
      locations."/".proxyWebsockets = true;
    };

    services.dnsmasq.settings.address = [ "/immich.${hostName}/${config.custom.staticIP}" ];

    services.homepage-dashboard.services = lib.mkOrder 300 [
      {
        "Photos" = [
          {
            Immich = {
              icon = "immich";
              href = "http://immich.${hostName}";
            };
          }
        ];
      }
    ];
  };
}
