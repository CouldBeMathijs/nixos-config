{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.transmission-custom;
  hostName = "${config.networking.hostName}.local";
in
{
  options.transmission-custom = {
    enable = lib.mkEnableOption "Enable my Transmission configuration with daemon and client";

    downloadDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/transmission/Downloads";
      description = "Where completed downloads are saved.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;
      openRPCPort = true;

      settings = {
        download-dir = cfg.downloadDir;
        rpc-bind-address = "0.0.0.0";
        rpc-port = 9091;

        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;

        encryption = 1;
        utp-enabled = true;
      };
    };

    environment.systemPackages = [ pkgs.transmission-remote-gtk ];

    services.nginx = {
      enable = true;

      appendHttpConfig = ''
        proxy_headers_hash_max_size 1024;
        proxy_headers_hash_bucket_size 128;
      '';

      virtualHosts."transmission.${hostName}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9091";
          proxyWebsockets = true;

          extraConfig = ''
            proxy_pass_header X-Transmission-Session-Id;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

    services.dnsmasq.settings.address = [ "/transmission.${hostName}/${config.custom.staticIP}" ];

    services.homepage-dashboard.services = lib.mkOrder 300 [
      {
        "Downloads" = [
          {
            "Transmission" = {
              icon = "transmission";
              href = "http://transmission.${hostName}";
            };
          }
        ];
      }
    ];
  };
}
