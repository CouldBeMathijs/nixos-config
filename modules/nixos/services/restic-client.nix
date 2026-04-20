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
    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra command line options to pass to restic.";
      example = [ "sftp.connections=1" ];
    };
    backups = lib.mkOption {
      description = "Definition of backup sets.";
      default = {
        home-backup = {
          paths = [ "/home" ];
        };
      };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            paths = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "Paths to back up for this set.";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.restic ];

    services.restic.backups = lib.mapAttrs (backupName: backupCfg: {
      repository = "placeholder";
      passwordFile = cfg.passwordFile;
      paths = backupCfg.paths;
      extraOptions = cfg.extraOptions;

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
        "**/.direnv" # Cache for direnv
        "**/.venv*"
        "**/__pycache__"
        "**/build" # General build folders
        "**/cmake-build*" # Cmake data directories (created by CLion)
        "**/dist" # General distribution folders
        "**/node_modules"
        "**/target" # Rust build artifacts
        "**/venv" # Python virtual enviorment

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
        "/mnt/storage/backups"
      ];
    }) cfg.backups;

    systemd.services = lib.mapAttrs' (
      backupName: backupCfg:
      let
        serviceName = "restic-backups-${backupName}";
        envFilePath = "/run/restic-${backupName}.env";
      in
      lib.nameValuePair serviceName {
        path = [
          pkgs.coreutils
          pkgs.gnused
          pkgs.iputils
        ];
        serviceConfig = {
          EnvironmentFile = "-${envFilePath}";
          Environment = [
            "RESTIC_TARGET_LIST=\"${lib.concatStringsSep " " locations}\""
          ];
          Restart = "on-failure";
          RestartSec = "1h";
        };

        preStart = ''
          FOUND_TARGET=""
          for TARGET in $RESTIC_TARGET_LIST; do
            # Robust Host Extraction
            HOST=$(echo "$TARGET" | sed -e 's|^[^:]*:||' -e 's|^//||' -e 's|.*@||' -e 's|[:/].*||')
            
            echo "Checking reachability for $HOST..."
            if [ -z "$HOST" ] || ping -c 1 -W 3 "$HOST" > /dev/null 2>&1; then
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

          echo "RESTIC_REPOSITORY=$FOUND_TARGET" > ${envFilePath}
        '';
      }
    ) cfg.backups;
  };
}
