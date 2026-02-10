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
    ./services/auto-updater.nix
    ./services/fwupd.nix
    ./services/homepage-dashboard.nix
    ./services/immich.nix
    ./services/jellyfin.nix
    ./services/pihole.nix
    ./services/reverse-proxy.nix
    ./services/ssh.nix
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

  # Global Defaults
  config = {
    audio.enable = lib.mkDefault true;
    cli-utils.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true;
    lix.enable = lib.mkDefault true;
    locale.enable = lib.mkDefault true;
    plymouth.enable = lib.mkDefault true;
    printing.enable = lib.mkDefault true;
    fwupd.enable = lib.mkDefault true;
  };
}
