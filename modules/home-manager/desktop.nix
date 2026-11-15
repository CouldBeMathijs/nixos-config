{ pkgs, lib, ... }:

{
  # Common desktop apps and utilities
  composing.enable = lib.mkDefault true;
  discord.enable = lib.mkDefault true;
  libreoffice.enable = lib.mkDefault true;
  mail.enable = lib.mkDefault true;
  minecraft.enable = lib.mkDefault true;
  zed.enable = lib.mkDefault true;
  zen-browser.enable = lib.mkDefault true;
  terminal.enable = lib.mkDefault true;

  # Shared packages across all desktops
  home.packages = with pkgs; [
    signal-desktop
    tor-browser
  ];

  # Hide the annoying cups entry and define ghostty
  xdg = {
    enable = true;
    desktopEntries = {
      "cups" = {
        name = "Cups Printer Manager";
        noDisplay = true;
      };
    };
  };
}
