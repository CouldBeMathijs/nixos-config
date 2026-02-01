{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.immich;
in
{
  options.immich = {
    enable = lib.mkEnableOption "Enable immich";

    # New option for the storage path
    mediaLocation = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/immich";
      description = "The path where Immich stores its photos and videos.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql.package = pkgs.postgresql_16;
    environment.systemPackages = with pkgs; [ immich-go ];
    # Automatically create the directory with correct permissions
    systemd.tmpfiles.rules = [
      "d ${cfg.mediaLocation} 0750 immich immich -"
    ];

    services.immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      openFirewall = true;

      # Use the path defined in the option
      mediaLocation = cfg.mediaLocation;

      database = {
        enable = true;
        enableVectors = true;
      };

      redis.enable = true;
      machine-learning.enable = true;
    };

    users.users.immich.extraGroups = [
      "video"
      "render"
    ];

    hardware.graphics.enable = true;
  };
}
