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
/*
  Extra steps needed:
  sudo vim /var/lib/restic-password # Create your password here
  sudo chmod 600 /var/lib/restic-password # Set permissions for the password file
  sudo restic -r [rest:http://nas-ip:8000/my-repo] init --password-file /var/lib/restic-password
*/

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

      # Comprehensive exclusion list
      exclude = [
        # --- General Bloat and caches ---
        "**/.cache"
        "**/Downloads"
        "**/.local/share/Trash"
        "**/.thumbnails"
        "**/direnv/prev" # Direnv stuff
        "**/.direnv"
        "**/vesktop/sessionData/Cache" # Vesktop cache does not support XDG

        # --- Development (The "Ignore These" Hall of Fame) ---
        "**/node_modules"
        "**/venv" # Python virtual enviorment
        "**/.venv"
        "**/cmake-build*" # Cmake data directories (created by CLion)
        "**/target" # Rust build artifacts
        "**/dist" # General distribution folders
        "**/build" # General build folders
        "**/.direnv" # Cache for direnv

        # --- Gaming ---
        "**/.local/share/Steam/steamapps/common" # The actual game files
        "**/.local/share/Steam/steamapps/downloading" # Temporary update files
        "**/.local/share/Steam/steamapps/shadercache" # Precompiled shaders
        "**/.paradoxlauncher"
        "**/GE-Proton-latest"
        "**/Games/Heroic"

        # --- AI Stuff ---
        "**/easy-diffusion"
        "**/.ollama"
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

    # Custom Systemd adjustments for retries and portability
    systemd.services.restic-backups-home-backup = {
      # The preStart script extracts the hostname/IP from the remoteLocation variable
      preStart = ''
        # Extract host: Remove protocol (rest:http://) and path/port suffix
        # Example: rest:http://zeus.local:8000/athena -> zeus.local
        REMOTE_HOST=$(echo "${cfg.remoteLocation}" | sed -e 's|.*://||' -e 's|[:/].*||')

        echo "Checking if backup target $REMOTE_HOST is reachable..."
        if ! ${pkgs.iputils}/bin/ping -c 1 "$REMOTE_HOST" > /dev/null 2>&1; then
          echo "Target $REMOTE_HOST unreachable. Service will retry in 1 hour."
          exit 1
        fi
      '';

      serviceConfig = {
        # Retry logic
        Restart = "on-failure";
        RestartSec = "1h";

        # Security: ensure it can't do much else
        PrivateTmp = true;
      };

      # Ensure it doesn't stop retrying after a few failures
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
    };
  };
}
