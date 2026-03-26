{ pkgs, lib, ... }:

{
  # Common desktop apps and utilities
  browser.enable = lib.mkDefault true;
  composing.enable = lib.mkDefault true;
  discord.enable = lib.mkDefault true;
  mail.enable = lib.mkDefault true;
  minecraft.enable = lib.mkDefault true;
  zed.enable = lib.mkDefault true;

  # Shared packages across all desktops
  home.packages = with pkgs; [
    signal-desktop
    libreoffice-fresh
  ];

  # Hide the annoying cups entry and define ghostty
  xdg = {
    enable = true;
    desktopEntries = {
      "cups" = {
        name = "Cups Printer Manager";
        noDisplay = true;
      };
      "com.mitchellh.ghostty" = {
        name = "Ghostty";
        genericName = "Terminal Emulator";
        comment = "A terminal emulator";
        exec = "ghostty";
        icon = "terminal";
        categories = [
          "System"
          "TerminalEmulator"
        ];
        startupNotify = true;
        terminal = false;
        actions = {
          new-window = {
            name = "New Window";
            exec = "ghostty";
          };
        };
      };
    };
  };

  # Ghostty terminal configuration
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    installBatSyntax = true;
    settings = {
      theme = "Gruvbox Dark Hard";
    };
  };
}
