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
    "localhost:${toString port}"
    "127.0.0.1:${toString port}"
  ];
in
{
  options.homepage-dashboard.enable = lib.mkEnableOption "Enable homepage-dashboard media server";

  config = lib.mkIf config.homepage-dashboard.enable {

    # Automatically enable the reverse proxy module when homepage is enabled
    services.reverse-proxy.enable = true;

    services.avahi = {
      enable = lib.mkDefault true;
      nssmdns4 = lib.mkDefault true;
      publish = {
        enable = lib.mkDefault true;
        addresses = lib.mkDefault true;
        userServices = lib.mkDefault true;
      };
    };

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
                href = "http://immich.${hostName}"; # Updated to Reverse Proxy URL
              };
            }
            {
              Jellyfin = {
                icon = "jellyfin";
                href = "http://jellyfin.${hostName}"; # Updated to Reverse Proxy URL
              };
            }
          ];
        }
        {
          "Networking" = [
            {
              "Pi-Hole" = {
                icon = "pi-hole";
                href = "http://pihole.${hostName}"; # Updated to Reverse Proxy URL
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
            disk = "/";
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
