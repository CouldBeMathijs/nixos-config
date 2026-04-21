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
      repository = "env://RESTIC_REPOSITORY";
      passwordFile = cfg.passwordFile;
      paths = backupCfg.paths;
      extraOptions = cfg.extraOptions;

      exclude = [
        "**/.cache"
        "**/Downloads"
        "**/.local/share/Trash"
        "**/.thumbnails"
        "**/direnv/prev"
        "**/.direnv"
        "**/vesktop/sessionData/Cache"

        "**/.direnv"
        "**/.venv*"
        "**/__pycache__"
        "**/build"
        "**/cmake-build*"
        "**/dist"
        "**/node_modules"
        "**/target"
        "**/venv"

        "**/.local/share/Steam/steamapps/common"
        "**/.local/share/Steam/steamapps/downloading"
        "**/.local/share/Steam/steamapps/shadercache"
        "**/.paradoxlauncher"
        "**/GE-Proton-latest"
        "**/Games/Heroic"

        "**/easy-diffusion"
        "**/.ollama"

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
            HOST=$(echo "$TARGET" | sed 's|^[^:]*://||' | sed 's|^[^@]*@||' | sed 's|:.*||' | sed 's|/.*||')

            if [ -z "$HOST" ]; then
              echo "Warning: Could not extract host from target: $TARGET"
              continue
            fi

            echo "Checking reachability for $HOST (from $TARGET)..."
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

          echo "RESTIC_REPOSITORY=$FOUND_TARGET" > ${envFilePath}
        '';
      }
    ) cfg.backups;
  };
}
