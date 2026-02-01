{
  pkgs,
  lib,
  config,
  ...
}:

let
  rawHost = config.networking.hostName;
  hostName = "${rawHost}.local";
  port = 8082;

  allowedList = [
    "${hostName}"
    "${hostName}:${toString port}"
    "${rawHost}"
    "${rawHost}:${toString port}"
    "localhost"
    "127.0.0.1"
    "localhost:${toString port}" # Added these for good measure
    "127.0.0.1:${toString port}"
  ];
in
{
  options.homepage-dashboard.enable = lib.mkEnableOption "Enable homepage-dashboard media server";

  config = lib.mkIf config.homepage-dashboard.enable {

    services.avahi = {
      enable = lib.mkDefault true;
      nssmdns4 = lib.mkDefault true;
      publish = {
        enable = lib.mkDefault true;
        addresses = lib.mkDefault true;
        userServices = lib.mkDefault true;
      };
    };

    # We use mkForce here to override the module's internal default
    systemd.services.homepage-dashboard.environment = {
      HOMEPAGE_ALLOWED_HOSTS = lib.mkForce (lib.concatStringsSep "," allowedList);
    };

    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      settings = {
        title = "Home Lab";
        server = {
          host = "0.0.0.0";
          inherit port;
        };
      };

      services = [
        {
          "Media" = [
            {
              Immich = {
                icon = "immich";
                href = "http://${hostName}:2283";
              };
            }
            {
              Jellyfin = {
                icon = "jellyfin";
                href = "http://${hostName}:8096";
              };
            }
          ];
        }
        {
          "Networking" = [
            {
              "Pi-Hole" = {
                icon = "pi-hole";
                href = "http://${hostName}:8080";
              };
            }
          ];
        }
      ];

      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/"; # Monitors the root partition
          };
        }
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];
    };
  };
}
