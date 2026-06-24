{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/nixos
  ];

  networking.hostName = "zeus"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  custom.staticIP = "192.168.1.100";

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  locale.code = "en_IE";

  # Server Services
  ssh.enable = true;
  homepage-dashboard.enable = true;
  tailscale.enable = true;
  jellyfin.enable = true;
  pihole.enable = true;
  lix.enable = false;
  transmission-custom.enable = true;
  immich = {
    enable = true;
    mediaLocation = "/mnt/storage/immich";
  };
  restic-server = {
    enable = true;
    dataDir = "/mnt/storage/backups";
  };
  calibre-web = {
    enable = false;
    libraryLocation = "/mnt/storage/calibre-web";
  };
  gitea.enable = false;
  restic-client = {
    enable = true;
    remoteLocation = [ "sftp:restic-user@192.168.1.130:/share/Backup/restic-repo" ];

    passwordFile = "/etc/restic-password";
    extraOptions = [ "sftp.connections=2" ];
    backups = {
      home-backup = {
        paths = [ "/home" ];
      };
      storage-backup = {
        paths = [
          "/mnt/jellyfin"
          "/mnt/storage"
        ];
      };
    };
  };

  # Samba Configuration
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "zeus";
        "netbios name" = "zeus";
        "security" = "user";
        # Map unauthenticated users to the guest account (nobody)
        "map to guest" = "Bad User";
      };
      "NAS" = {
        "path" = "/mnt/storage/NAS";
        "browseable" = "yes";
        "guest ok" = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "zeus";
      };
    };
  };

  # Network Discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      workstation = true;
      userServices = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zeus = {
    isNormalUser = true;
    description = "Zeus";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  programs.zsh.enable = true;

  # Hardware acceleration
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    ffmpeg
    libva
    libvdpau
    tmux
    vulkan-tools
    vulkan-validation-layers
  ];
}
