{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    pihole.enable = lib.mkEnableOption "Enable Pi-hole DNS and web interface";
  };

  config = lib.mkIf config.pihole.enable {
    networking.hosts = {
      "192.168.33.1" = [
        "gateway.homelab.me"
        "gateway"
      ];
      "192.168.33.2" = [
        "pi-hole.homelab.me"
        "pi-hole"
      ];
      "192.168.33.15" = [
        "nas.homelab.me"
        "nas"
      ];
    };

    services = {
      dnsmasq = {
        enable = false;
        settings = {
          address = [
            "/feelinsonice-hrd.appspot.com/ # Block Snapchat"
            "/feelinsonice.appspot.com/ # Block Snapchat"
            "/snapchat.com/ # Block Snapchat"
          ];
          dhcp-name-match = [
            "set:hostname-ignore,wpad"
            "set:hostname-ignore,localhost"
          ];
          dhcp-option = [
            "vendor:MSFT,2,1i"
            "6,192.168.33.2"
          ];
          domain = [
            "homelab.me,192.168.33.0/24,local"
          ];
        };
      };

      pihole-ftl = {
        enable = true;

        lists = [
          {
            url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
            type = "block";
            enabled = true;
            description = "Steven Black's HOSTS";
          }
          {
            url = "https://justdomains.github.io/blocklists/lists/easylist-justdomains.txt";
            type = "block";
            enabled = true;
            description = "EasyList (just domains)";
          }
          {
            url = "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt";
            type = "block";
            enabled = true;
            description = "Polish Filters Team – KADhosts";
          }
          {
            url = "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts";
            type = "block";
            enabled = true;
            description = "FadeMind Spam hosts";
          }
          {
            url = "https://v.firebog.net/hosts/static/w3kbl.txt";
            type = "block";
            enabled = true;
            description = "Firebog – w3kbl";
          }
          {
            url = "https://adaway.org/hosts.txt";
            type = "block";
            enabled = true;
            description = "AdAway hosts";
          }
          {
            url = "https://v.firebog.net/hosts/AdguardDNS.txt";
            type = "block";
            enabled = true;
            description = "Firebog – AdGuard DNS";
          }
          {
            url = "https://v.firebog.net/hosts/Admiral.txt";
            type = "block";
            enabled = true;
            description = "Firebog – Admiral";
          }
          {
            url = "https://v.firebog.net/hosts/Easyprivacy.txt";
            type = "block";
            enabled = true;
            description = "Firebog – EasyPrivacy";
          }
          {
            url = "https://v.firebog.net/hosts/Prigent-Ads.txt";
            type = "block";
            enabled = true;
            description = "Firebog – Prigent Ads";
          }
        ];

        openFirewallDNS = true;
        openFirewallDHCP = true;
        openFirewallWebserver = true;
        queryLogDeleter.enable = true;
        useDnsmasqConfig = true;

        settings = {
          dhcp = {
            active = false;
            start = "192.168.33.61";
            end = "192.168.33.254";
            hosts = [
              "00:00:5e:00:53:01,192.168.33.22,jane-laptop"
              "00:00:5e:00:53:ab,bill-desktop"
              "00:00:5e:00:53:ff,office-printer"
            ];
            ipv6 = false;
            leaseTime = "24h";
            rapidCommit = true;
            resolver.resolveIPv6 = false;
            router = "192.168.33.1";
          };

          dns = {
            cnameRecords = [
              "color-printer,office-printer"
              "color-printer.homelab.me,office-printer.homelab.me"
            ];
            domain = "homelab.me";
            domainNeeded = true;
            expandHosts = true;
            interface = "eth0";
            hosts = [
              "192.168.33.1   gateway gateway.homelab.me"
              "192.168.33.2   pi-hole pi-hole.homelab.me"
              "192.168.33.15  nas nas.homelab.me"
            ];
            upstreams = [
              "1.1.1.1"
              "1.1.1.2"
            ];
          };

          ntp = {
            ipv4.active = false;
            ipv6.active = false;
            sync.active = false;
          };

          webserver = {
            api.pwhash = "$BALLOON-SHA256...";
            session.timeout = 43200;
          };
        };
      };

      pihole-web = {
        enable = true;
        ports = [ 80 ];
      };

      resolved = {
        extraConfig = ''
          DNSStubListener=no
          MulticastDNS=off
        '';
      };
    };

    system.activationScripts = {
      print-pi-hole = {
        text = builtins.trace "building the pi-hole configuration..." "";
      };
    };

    systemd.tmpfiles.rules = [
      "f /etc/pihole/versions 0644 pihole pihole - -"
    ];
  };
}
