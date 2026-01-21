{
  pkgs,
  lib,
  config,
  stylix,
  ...
}:

{
  options = {
    # Custom option to enable this module
    gnome-stylix.enable = lib.mkEnableOption "enable stylix with custom gnome dconf settings";
  };

  config = lib.mkIf config.gnome-stylix.enable {
    # 1. Install the Nerd Font package globally for Home Manager to access
    home.packages = [
      pkgs.nerd-fonts.jetbrains-mono
    ];

    # 2. Enable Stylix core features
    stylix.enable = true;

    # 3. Configure the Stylix Color Scheme (Base16 Gruvbox Dark Hard)
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    # 4. Enable Stylix targets for GNOME/GTK
    stylix.targets = {
      gtk.enable = true;
      gnome.enable = true;
    };

    # 5. Configure Fonts (Uniform JetBrainsMono Nerd Font)
    stylix.fonts = {
      # Since the package is installed via home.packages, Stylix only needs the name.
      # You can safely provide the package attribute again, using the top-level
      # attribute for simplicity, which Home Manager and Stylix often handle correctly.

      # Define the base font
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        # Using the simplified package name, which Stylix often needs to install the theme components.
        # If this still errors, set 'package = null;' but that's less reliable for Stylix theming.
        name = "JetBrainsMono Nerd Font";
      };

      # Use the monospace definition for sans-serif and serif for uniformity
      sansSerif = config.stylix.fonts.monospace;
      serif = config.stylix.fonts.monospace;

      # Keep a standard emoji font separate
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      # Set the size
      sizes.desktop = 11;
    };

    # 6. Dconf Settings (Non-theming settings retained)
    xdg.enable = true;
    dconf.enable = true;
    dconf.settings = {
      # Change button layout
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,minimize,maximize:appmenu";
      };

      # Privacy settings
      "org/gnome/desktop/privacy" = {
        recent-files-max-age = 30;
        old-files-age = 30;
        remove-old-temp-files = true;
        remove-old-trash-files = true;
      };

      # Fractional scaling
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
    };

    # 7. Cursor (Managed by Home Manager/Stylix via this option)
    home.pointerCursor = {
      enable = true;
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Gruvbox)";
    };
  };
}
