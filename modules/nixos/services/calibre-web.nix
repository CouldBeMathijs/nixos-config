{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "calibre-web";
  cfg = config.${name};
  hostName = "${config.networking.hostName}.local";
  cwCfg = config.services.calibre-web;
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "calibre-web";
    };
    libraryLocation = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure the directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.libraryLocation} 0750 calibre-web calibre-web -"
    ];

    services.calibre-web = {
      enable = true;
      openFirewall = true;
      dataDir = cfg.dataDir;
      listen.ip = "0.0.0.0";
      options = {
        calibreLibrary = cfg.libraryLocation;
        enableBookUploading = true;
        enableBookConversion = true;

      };
    };

    # Combined Setup Script
    systemd.services.calibre-web.serviceConfig.ExecStartPre = lib.mkForce (
      pkgs.writeShellScript "calibre-web-check" ''
        # 1. Check for metadata.db
        if [ ! -f "${cfg.libraryLocation}/metadata.db" ]; then
          echo "----------------------------------------------------------"
          echo "ERROR: Calibre library not found at ${cfg.libraryLocation}"
          echo "Please place an existing 'metadata.db' file in that folder."
          echo "Ownership should be calibre-web:calibre-web."
          echo "----------------------------------------------------------"
          exit 1
        fi

        # 2. Run standard migrations if DB exists
        appDb="/var/lib/${cwCfg.dataDir}/app.db"
        gdriveDb="/var/lib/${cwCfg.dataDir}/gdrive.db"
        __RUN_MIGRATIONS_AND_EXIT=1 ${cwCfg.package}/bin/calibre-web -p "$appDb" -g "$gdriveDb"
      ''
    );

    services.nginx.virtualHosts."books.${hostName}" = {
      locations."/".proxyPass = "http://127.0.0.1:8083";
      locations."/".proxyWebsockets = true;
      extraConfig = "client_max_body_size 5000M;";
    };

    services.dnsmasq.settings.address = [ "/books.${hostName}/${config.custom.staticIP}" ];

    services.homepage-dashboard.services = lib.mkOrder 899 [
      {
        "Books" = [
          {
            Calibre = {
              icon = "calibre-web";
              href = "http://books.${hostName}";
            };
          }
        ];
      }
    ];
  };
}
