# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  networking.hostName = "athena";

  plasma.enable = true;
  plasma-apps.enable = true;

  schoolutils.cn.enable = true;
  ripping.enable = false;
  tailscale.enable = true;
  virtualbox.enable = true;

  restic-client = {
    enable = true;
    remoteLocation = [
      "rest:http://zeus.local:8000/athena"
      "rest:http://zeus.tail65fbd9.ts.net:8000/athena"
    ];
    passwordFile = "/var/lib/restic-password";
  };

  imports = [
    ./../../modules/nixos
    ./../../modules/desktop.nix
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
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireshark"
    ];
  };
  programs.zsh.enable = true;
  locale.language = "irish";
}
