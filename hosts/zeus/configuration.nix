# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/nixos
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "zeus"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  custom.staticIP = "192.168.1.100";

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  locale.language = "irish";

  fonts.enable = false;
  homepage-dashboard.enable = true;
  jellyfin.enable = true;
  pihole.enable = true;
  plymouth.enable = false;
  printing.enable = false;
  ssh.enable = true;
  immich = {
    enable = true;
    mediaLocation = "/mnt/storage/immich";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zeus = {
    isNormalUser = true;
    description = "Zeus";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Hardware acceleration
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    libva
    libvdpau
    vulkan-tools
    vulkan-validation-layers
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
