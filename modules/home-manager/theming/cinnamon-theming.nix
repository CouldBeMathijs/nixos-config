{
  pkgs,
  gruvbox-plus-icons-git,
  lib,
  config,
  ...
}:

{
  options = {
    cinnamon-theming.enable = lib.mkEnableOption "enable cinnamon theming";
  };

  config = lib.mkIf config.cinnamon-theming.enable {
    xdg.enable = true;
    home.packages = with pkgs; [ dconf-editor ];
    dconf.enable = true;
    dconf.settings = {
      # Cinnamon-specific settings go here
      # Example: change panel button layout or other settings if applicable

      # Privacy settings - similar to GNOME but check if applicable for Cinnamon
      "org/cinnamon/desktop/privacy" = {
        recent-files-max-age = 30;
        old-files-age = 30;
        remove-old-temp-files = true;
        remove-old-trash-files = true;
      };

      # Font settings
      "org/cinnamon/desktop/interface" = {
        document-font-name = "JetBrainsMono Nerd Font 11";
        font-name = "JetBrainsMono Nerd Font 11";
        monospace-font-name = "JetBrainsMono Nerd Font 11";
      };

      "org/cinnamon/desktop/wm/preferences" = {
        button-layout = "close,minimize,maximize:appmenu";
      };

      # Fractional scaling for mutter might not apply to Cinnamon's muffin (fork of mutter),
      # but you could try enabling experimental features or relevant Cinnamon compositor settings here
    };

    # GTK theming setup
    gtk = {
      enable = true;
      theme = {
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme.override {
          tweakVariants = [ "macos" ];
        };
      };
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = gruvbox-plus-icons-git;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;

      # Enable GTK4 theming explicitly
      gtk4.extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
        # Optional: you can add more GTK4-specific configs here if needed
      };
    };

    # Cinnamon-specific theming configuration (if supported)
    # Cinnamon doesn’t have a native “programs.cinnamon-shell.theme” config like GNOME
    # but you can still override via XDG config files:

    xdg.configFile = {
      "gtk-4.0/assets".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}
