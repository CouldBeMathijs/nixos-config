{
  pkgs,
  lib,
  config,
  ...
}:

let
  name = "homepage-dashboard";
  cfg = config.${name};
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
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };

  config = lib.mkIf cfg.enable {
    # Automatically enable the reverse proxy module when homepage is enabled
    services.reverse-proxy.enable = true;
    # mDNS configuration for local network discovery
    services.avahi = {
      enable = lib.mkDefault true;
      nssmdns4 = lib.mkDefault true;
      publish = {
        enable = lib.mkDefault true;
        addresses = lib.mkDefault true;
        userServices = lib.mkDefault true;
      };
    };

    # Security: restrict allowed hosts for the dashboard
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

      # System-wide performance and utility widgets
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
