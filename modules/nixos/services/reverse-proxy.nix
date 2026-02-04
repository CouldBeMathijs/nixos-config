{ config, lib, ... }:

let
  cfg = config.services.reverse-proxy;
  hostName = "${config.networking.hostName}.local";
  serverIP = "192.168.1.100";
in
{
  options.services.reverse-proxy.enable = lib.mkEnableOption "Enable Nginx and DNS for home services";

  config = lib.mkIf cfg.enable {
    services.dnsmasq.settings = {
      address = [
        "/${hostName}/${serverIP}"
        "/jellyfin.${hostName}/${serverIP}"
        "/immich.${hostName}/${serverIP}"
        "/pihole.${hostName}/${serverIP}"
      ];
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "${hostName}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8082";
            proxyWebsockets = true;
          };
        };

        "jellyfin.${hostName}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
            proxyWebsockets = true;
          };
        };

        "immich.${hostName}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:2283";
            proxyWebsockets = true;
          };
        };

        "pihole.${hostName}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
            proxyWebsockets = true;
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
