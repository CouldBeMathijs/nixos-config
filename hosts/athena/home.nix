{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [
    ../../modules/home-manager
  ];

  config = {
    # Enable shell configuration
    shell.fish.enable = true;

    # Enable fastfetch configuration
    fastfetch.enable = true;

    # Enable Plasma config
    plasma-theming.enable = true;

    # Enable Jetbrains IDE's
    jetbrains.clion.enable = true;

    # Enable logisim and mars-mips
    csa-utils.enable = false;

    # Enable LaTeX
    latex.enable = true;
    latex.gnome-apps = true;

    # niri-config.enable = false;
    fun-cli.enable = true;
    dosbox.enable = true;

    # Enable musescore
    composing.enable = true;
    discord.enable = true;
    gramps.enable = true;
    minecraft.enable = true;

    home.homeDirectory = "/home/mathijs";
    home.username = "mathijs";
    # This value determines the Home Manager release that your configuration is
    # compatible with.
    home.stateVersion = "25.05"; # Do not change unless you know what you are doing!
    home.packages = with pkgs; [
      obs-studio # Record you screen
      audacity # Audio recording and editing
      shotcut # Video editing
      kdePackages.kwordquiz # Flash card builder
      kooha

      # Messaging apps
      signal-desktop

      # Documents
      libreoffice-fresh
    ];

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

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
