{
  pkgs,
  gruvbox-plus-icons-git,
  lib,
  config,
  ...
}:
let
  name = "cinnamon-theming";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    xdg.enable = true;
    home.packages = with pkgs; [ dconf-editor ];
    dconf.enable = true;
    dconf.settings = {
      # Privacy settings
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
      };
    };

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
