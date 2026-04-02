{ lib, config, ... }:
{
  imports = [
    ./DE-WM/cinnamon.nix
    ./DE-WM/gnome.nix
    ./DE-WM/niri.nix
    ./DE-WM/plasma.nix
    ./DE-WM/xfce.nix
    ./programs/cli-utils.nix
    ./programs/fonts.nix
    ./programs/gaming.nix
    ./programs/gnome-apps.nix
    ./programs/plasma-apps.nix
    ./programs/ripping.nix
    ./programs/schoolutils.nix
    ./programs/virtualbox.nix
    ./services/auto-updater.nix
    ./services/bluetooth.nix
    ./services/calibre-web.nix
    ./services/fwupd.nix
    ./services/homepage-dashboard.nix
    ./services/immich.nix
    ./services/jellyfin.nix
    ./services/pihole.nix
    ./services/restic-client.nix
    ./services/restic-server.nix
    ./services/reverse-proxy.nix
    ./services/ssh.nix
    ./services/tailscale.nix
    ./systems/audio.nix
    ./systems/lix.nix
    ./systems/locale.nix
    ./systems/plymouth.nix
    ./systems/printing.nix
    ./systems/sddm-minimal-theme.nix
  ];

  options = {
    custom.staticIP = lib.mkOption {
      type = lib.types.str;
      description = "The static IP address of the server.";
    };
  };
}
