{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "gnome";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    services.xserver = {
      excludePackages = with pkgs; [
        xterm # Why is it here by default
      ];
    };
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    # Disable some applications
    environment.gnome.excludePackages = (
      with pkgs;
      [
        decibels # Default audio player
        epiphany # Default web browser
        evince # Default deprecated document viewer (superceded by papers)
        geary # Default mail client
        gnome-characters # Unicode character list
        gnome-connections # Remote desktop client
        gnome-console # Default terminal client
        gnome-music # Default music player
        gnome-system-monitor # Default system monitor
        gnome-tour # System tour
        nixos-render-docs # Nixos docs
        totem # Default deprecated video player
        yelp # Gnome help and docs
      ]
    );
    xdg.icons.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
    };

    # Gnome customization applications
    environment.systemPackages = with pkgs; [
      dconf-editor # I get why this isn't in gnome-settings
      desktop-file-utils
      gnome-tweaks # But this should be
      mission-center # Windows like system monitor
    ];

  };
}
