{ lib, ... }:

{
  # Bootloader defaults
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Networking
  networking.networkmanager.enable = lib.mkDefault true;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Default State Version
  system.stateVersion = lib.mkDefault "25.11";
}
