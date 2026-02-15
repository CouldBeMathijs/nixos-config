{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "restic-client";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable Restic backup client";
    remoteLocation = lib.mkOption {
      type = lib.types.str;
      example = "rest:http://nas-ip:8000/my-repo";
      description = "The URL of the restic server repository.";
    };
    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the file containing the repo password.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.restic ];

    services.restic.backups.home-backup = {
      repository = cfg.remoteLocation;
      passwordFile = cfg.passwordFile;

      paths = [ "/home" ];
      exclude = [
        "**/.cache"
        "**/node_modules"
        "**/Downloads"
      ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
    };
  };
}
