{ lib, ... }:

{
  # Modules enabled in each system
  cli-utils.enable = lib.mkDefault true;
  fwupd.enable = lib.mkDefault true;
  locale.enable = lib.mkDefault true;
  lix.enable = lib.mkDefault true;
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
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
