{
  pkgs,
  lib,
  config,
  ...
}:

let
  hostName = "${config.networking.hostName}.local";
in
{
  options.jellyfin.enable = lib.mkEnableOption "Enable Jellyfin";

  config = lib.mkIf config.jellyfin.enable {
    services.jellyfin.enable = true;

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    services.nginx.virtualHosts."jellyfin.${hostName}" = {
      locations."/".proxyPass = "http://127.0.0.1:8096";
      locations."/".proxyWebsockets = true;
    };

    services.dnsmasq.settings.address = [ "/jellyfin.${hostName}/${config.custom.staticIP}" ];

    services.homepage-dashboard.services = lib.mkOrder 901 [
      {
        "Media" = [
          {
            Jellyfin = {
              icon = "jellyfin";
              href = "http://jellyfin.${hostName}";
            };
          }
        ];
      }
    ];
  };
}
