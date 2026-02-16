# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  networking.hostName = "athena";

  # Enable Desktops and all packages around it
  plasma.enable = true;
  plasma-apps.enable = true;

  virtualbox.enable = true;
  cn-utils.enable = true;

  ripping.enable = false;

  # Enable networking
  networking.networkmanager.enable = true;

  imports = [
    ./../../modules/nixos
  ];

  services = {
    envfs.enable = true;

  };

  security = {
    rtkit.enable = true;
    sudo-rs.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mathijs = {
    isNormalUser = true;
    description = "Mathijs Pittoors";
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireshark"
    ];
  };
  locale.language = "irish";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Media
    gimp # GNU Image Manipulation Program
  ];
  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Do not change me unless you know what you are doing!! Check documentation first!!
  system.stateVersion = "25.05"; # Did you read the comment?

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
