{ config, lib, ... }:

let
  cfg = config.services.reverse-proxy;
  hostName = "${config.networking.hostName}.local";
  serverIP = "192.168.1.100";
in
{
  options.services.reverse-proxy.enable = lib.mkEnableOption "Enable Nginx and DNS for home services";

  config = lib.mkIf cfg.enable {
    # Local DNS resolution via dnsmasq
    services.dnsmasq.settings = {
      address = [
        "/${hostName}/${serverIP}"
      ];
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        # Primary dashboard entry point
        "${hostName}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8082";
            proxyWebsockets = true;
          };
        };
      };
    };

    # Standard web traffic ports
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
