{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    gnome-extensions.enable = lib.mkEnableOption "enable gnome-extensions";
  };

  config = lib.mkIf config.gnome-extensions.enable {
    home.packages = with pkgs.gnomeExtensions; [
      alphabetical-app-grid # Back to GNOME 3.2x
      appindicator # Yes, I know I shouldn't
      caffeine # Stay awake, screen
      hot-edge # When the top left is to far away
      # maximize-to-empty-workspace # MacOS did something right here
      open-desktop-file-location # Great debugging help
      paperwm # Scrolling window management
      # rounded-window-corners-reborn # Should be default
      user-themes # Classic
    ];
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [
            alphabetical-app-grid.extensionUuid # Back to GNOME 3.2x
            appindicator.extensionUuid # Yes, I know I shouldn't
            caffeine.extensionUuid # Stay awake, screen
            hot-edge.extensionUuid # When the top left is to far away
            # maximize-to-empty-workspace.extensionUuid # MacOS did something right here
            open-desktop-file-location.extensionUuid # Great debugging help
            paperwm.extensionUuid # Scrolling window management
            # rounded-window-corners-reborn.extensionUuid # Should be default
            user-themes.extensionUuid # Classic
          ];
          disable-extension-version-validation = true;
        };

        # Extensions settings
        "org/gnome/shell/extensions/hot-edge" = {
          enable-hot-edge = true;
        };

        # "org/gnome/shell/extensions/blur-my-shell/panel" = {
        # override-background-dynamically = true;
        # };

        "org/gnome/shell/extensions/vitals" = {
          icon-style = 1; # GNOME-style icons
          position-in-panel = 2; # Right, left of system menu
        };
      };
    };
  };
}
