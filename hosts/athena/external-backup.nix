{ config, pkgs, ... }:

let
  targetUuid = "ac21d4ec-7a5e-4836-bcdb-9430dd641c94";
  mountPoint = "/mnt/external-backup";
  remoteMount = "/mnt/remote-nas";
  remoteUser = "zeus";

  backupScript = pkgs.writeShellApplication {
    name = "restic-hdd-backup";
    runtimeInputs = with pkgs; [
      util-linux
      restic
      coreutils
      openssh
      sshfs
    ];
    text = ''
      set -e
      mkdir -p "${mountPoint}" "${remoteMount}"
      export RESTIC_CACHE_DIR="/var/cache/restic"

      # Mount local external HDD
      if ! mountpoint -q "${mountPoint}"; then
        mount /dev/disk/by-uuid/"${targetUuid}" "${mountPoint}"
      fi

      # Ensure clean unmount of both shares on script completion or failure
      cleanup() {
        if mountpoint -q "${remoteMount}"; then
          umount -l "${remoteMount}" || true
        fi
        if mountpoint -q "${mountPoint}"; then
          umount "${mountPoint}" || true
        fi
      }
      trap cleanup EXIT

      # Mount remote NAS files via SSHFS
      if ! mountpoint -q "${remoteMount}"; then
        sshfs -o IdentityFile=/root/.ssh/id_ed25519,reconnect,ServerAliveInterval=15 \
          "${remoteUser}@zeus.tail65fbd9.ts.net:/mnt/storage/NAS" "${remoteMount}"
      fi

      export RESTIC_PASSWORD_FILE="/etc/nixos/secrets/external-backup-password"

      # Initialize target repo on the external HDD if it does not exist yet
      if [ ! -f "${mountPoint}/restic-repo/config" ]; then
        restic -r "${mountPoint}/restic-repo" init
      fi

      # Run restic backup on the remote files
      restic -r "${mountPoint}/restic-repo" backup "${remoteMount}" -v
    '';
  };
in
{
  systemd.services.restic-hdd-backup = {
    description = "Automated Restic Sync on HDD Insertion";
    wantedBy = [ ];
    after = [
      "network-online.target"
      "tailscaled.service"
    ];
    wants = [
      "network-online.target"
      "tailscaled.service"
    ];
    path = [
      pkgs.openssh
      pkgs.sshfs
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupScript}/bin/restic-hdd-backup";
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{DEVTYPE}=="partition", ENV{ID_FS_UUID}=="${targetUuid}", TAG+="systemd", ENV{SYSTEMD_WANTS}="restic-hdd-backup.service"
  '';
}
