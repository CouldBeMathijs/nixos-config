{
  pkgs,
  lib,
  config,
  ...
}:

let
  # Load secrets from the local JSON file.
  secretsFile = ./secrets.json;
  secrets =
    if builtins.pathExists secretsFile then
      builtins.fromJSON (builtins.readFile secretsFile)
    else
      { pihole_hash = ""; };
in
{
  options = {
    pihole.enable = lib.mkEnableOption "Enable Pi-hole DNS and web interface";
  };

  config = lib.mkIf config.pihole.enable {
    services = {
      dnsmasq.enable = false;

      pihole-ftl = {
        enable = true;

        # These lists require webserver logic to be "enabled" to pass Nix checks
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
          dns = {
            upstreams = [
              "8.8.8.8"
              "8.8.4.4"
              "208.67.222.222"
              "208.67.220.220"
              "1.1.1.1"
              "1.0.0.1"
            ];
            domain = "local";
            domainNeeded = true;
            expandHosts = true;
            bogusPriv = true;
          };

          dhcp.active = false; # Set to false as requested for "no hardcoded network"

          webserver = {
            active = true;
            # v6 requirement: Port must be a STRING to satisfy the Nix module's parser
            port = "8080";
            api.pwhash = secrets.pihole_hash;
            session.timeout = 1800;
          };

          misc.privacylevel = 0;
        };
      };

      pihole-web = {
        # Set to true to satisfy the Nix Assertion
        enable = true;
        ports = [ 8080 ];
      };

      # CRITICAL: Force-disable the legacy lighttpd webserver so it doesn't
      # conflict with the new v6 integrated webserver on port 8080.
      lighttpd.enable = lib.mkForce false;

      resolved.extraConfig = "DNSStubListener=no";
    };

    systemd.tmpfiles.rules = [
      "f /etc/pihole/versions 0644 pihole pihole - -"
    ];
  };
}
