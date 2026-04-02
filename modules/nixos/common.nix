{ lib, ... }:

{
  # Modules enabled in each system
  cli-utils.enable = true;
  fwupd.enable = true;
  locale.enable = true;
  lix.enable = true;

  # Boot
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    kernelModules = [ "ntsync" ];
  };
  # Networking
  networking.networkmanager.enable = lib.mkDefault true;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security = {
    sudo-rs.enable = lib.mkDefault true;
    rtkit.enable = lib.mkDefault true;
  };

  # Default State Version
  system.stateVersion = lib.mkDefault "25.11";
}
