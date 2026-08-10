{
  lib,
  config,
  pkgs,
  gruvbox-plus-icons-git,
  ...
}:
{
  options.niri-config = {
    enable = lib.mkEnableOption "Enable niri-config configuration";
  };

  config = lib.mkIf config.niri-config.enable {

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = "*";
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
    };

    dconf = {
      enable = true;
      settings = {
        # Change button layout
        "org/gnome/desktop/wm/preferences" = {
          button-layout = ":appmenu";
        };

        # Privacy settings
        "org/gnome/desktop/privacy" = {
          recent-files-max-age = 30;
          old-files-age = 30;
          remove-old-temp-files = true;
          remove-old-trash-files = true;
        };

        # Font settings
        "org/gnome/desktop/interface" = {
          document-font-name = "JetBrainsMono Nerd Font 11";
          font-name = "JetBrainsMono Nerd Font 11";
          monospace-font-name = "JetBrainsMono Nerd Font 11";
        };
      };
    };

    programs.noctalia = {
      enable = true;
      settings = ../../../non-nixlang/noctalia.toml;
    };
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = gruvbox-plus-icons-git;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.theme = null;
    };

    xdg.configFile = {
      "gtk-4.0/assets".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css" = {
        source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
        force = true;
      };
      "gtk-4.0/gtk-dark.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };

    xdg.configFile."niri/config.kdl".source = ../../../non-nixlang/niri-config.kdl;
    xdg.configFile."niri/noctalia.kdl".source = ../../../non-nixlang/niri-noctalia-colors.kdl;
  };
}
