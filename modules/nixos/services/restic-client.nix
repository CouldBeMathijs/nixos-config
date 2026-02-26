{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "restic-client";
  cfg = config.${name};
  locations = if lib.isList cfg.remoteLocation then cfg.remoteLocation else [ cfg.remoteLocation ];
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable Restic backup client";
    remoteLocation = lib.mkOption {
      type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
      description = "The URL or list of URLs of the restic server repository.";
    };
    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the file containing the repo password.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.restic ];

    services.restic.backups.home-backup = {
      repository = "placeholder";
      passwordFile = cfg.passwordFile;
      paths = [ "/home" ];

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

        # --- Virtualbox ---
        "**/Virtualbox VMs"
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

    systemd.services.restic-backups-home-backup = {
      path = [
        pkgs.coreutils
        pkgs.gnused
        pkgs.iputils
      ];

      serviceConfig = {
        EnvironmentFile = "-/run/restic-home-backup.env";

        # Escaped quotes ensure systemd treats the list as a single variable
        Environment = [
          "RESTIC_TARGET_LIST=\"${lib.concatStringsSep " " locations}\""
        ];

        Restart = "on-failure";
        RestartSec = "1h";
      };

      preStart = ''
        FOUND_TARGET=""
        # Iterate through the targets
        for TARGET in $RESTIC_TARGET_LIST; do
          HOST=$(echo "$TARGET" | sed -e 's|.*://||' -e 's|[:/].*||')
          
          echo "Checking reachability for $HOST..."
          if ping -c 1 -W 3 "$HOST" > /dev/null 2>&1; then
            echo "Successfully reached $HOST. Selection: $TARGET"
            FOUND_TARGET="$TARGET"
            break
          else
            echo "$HOST unreachable, trying next..."
          fi
        done

        if [ -z "$FOUND_TARGET" ]; then
          echo "Error: No reachable backup targets found."
          exit 1
        fi

        echo "RESTIC_REPOSITORY=$FOUND_TARGET" > /run/restic-home-backup.env
      '';
    };
  };
}
