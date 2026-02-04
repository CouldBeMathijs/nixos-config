{
  pkgs,
  lib,
  config,
  ...
}:

let
  secretsFile = ./secrets.json;
  secrets =
    if builtins.pathExists secretsFile then
      builtins.fromJSON (builtins.readFile secretsFile)
    else
      { pihole_hash = ""; };

  hostName = "${config.networking.hostName}.local";
  serverIP = config.custom.staticIP;
in
{
  options.pihole.enable = lib.mkEnableOption "Enable Pi-hole DNS and web interface";

  config = lib.mkIf config.pihole.enable {
    # 1. Core Service Configuration
    services = {
      dnsmasq.enable = false;
      pihole-ftl = {
        enable = true;
        lists = [
          {
            url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
            type = "block";
            enabled = true;
          }
          {
            url = "https://justdomains.github.io/blocklists/lists/easylist-justdomains.txt";
            type = "block";
            enabled = true;
          }
          {
            url = "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt";
            type = "block";
            enabled = true;
          }
          {
            url = "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts";
            type = "block";
            enabled = true;
          }
          {
            url = "https://v.firebog.net/hosts/static/w3kbl.txt";
            type = "block";
            enabled = true;
          }
          {
            url = "https://adaway.org/hosts.txt";
            type = "block";
            enabled = true;
          }
          {
            url = "https://v.firebog.net/hosts/AdguardDNS.txt";
            type = "block";
            enabled = true;
          }
          {
            url = "https://v.firebog.net/hosts/Admiral.txt";
            type = "block";
            enabled = true;
          }
          {
            url = "https://v.firebog.net/hosts/Easyprivacy.txt";
            type = "block";
            enabled = true;
          }
          {
            url = "https://v.firebog.net/hosts/Prigent-Ads.txt";
            type = "block";
            enabled = true;
          }
          {
            url = "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt";
            type = "block";
            enabled = true;
          }
        ];

        openFirewallDNS = true;
        openFirewallWebserver = true;
        useDnsmasqConfig = true;

        settings = {
          dns.upstreams = [
            "8.8.8.8"
            "8.8.4.4"
            "1.1.1.1"
            "1.0.0.1"
          ];
          dns.domain = "local";
          webserver = {
            active = true;
            port = "8080";
            api.pwhash = secrets.pihole_hash;
          };
        };
      };
      pihole-web = {
        enable = true;
        ports = [ 8080 ];
      };
      lighttpd.enable = lib.mkForce false;
      resolved.extraConfig = "DNSStubListener=no";
    };

    systemd.tmpfiles.rules = [ "f /etc/pihole/versions 0644 pihole pihole - -" ];

    # 2. Reverse Proxy Configuration
    services.nginx.virtualHosts."pihole.${hostName}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
    };

    # 3. DNS Configuration
    services.dnsmasq.settings.address = [
      "/pihole.${hostName}/${serverIP}"
    ];

    # 4. Homepage Dashboard Entry
    services.homepage-dashboard.services = [
      {
        "Networking" = [
          {
            "Pi-Hole" = {
              icon = "pi-hole";
              href = "http://pihole.${hostName}";
            };
          }
        ];
      }
    ];
  };
}
