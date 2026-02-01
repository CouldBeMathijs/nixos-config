{
  pkgs,
  lib,
  config,
  ...
}:

let
  localIP = "192.168.1.250";
in
{
  options.homepage-dashboard.enable = lib.mkEnableOption "Enable homepage-dashboard media server";

  config = lib.mkIf config.homepage-dashboard.enable {

    environment.systemPackages = with pkgs; [
      homepage-dashboard
    ];
    services.homepage-dashboard = {
      enable = true;

      settings = {
        title = "Home Lab";

        server = {
          host = "0.0.0.0";
          port = 8082;
        };
      };

      services = [
        {
          "Media" = [
            {
              Jellyfin = {
                icon = "jellyfin";
                href = "http://${localIP}:8096";
              };
            }
          ];
        }
      ];
    };

  };
}
