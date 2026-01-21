{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    cinnamon.enable = lib.mkEnableOption "Enable Cinnamon desktop environment";
  };

  config = lib.mkIf config.cinnamon.enable {
    services.xserver = {
      enable = true;

      # Use LightDM as the display manager
      displayManager.lightdm.enable = true;

      # Enable Cinnamon desktop
      desktopManager.cinnamon.enable = true;

      excludePackages = with pkgs; [
        xterm
      ];
    };

    # Enable icons for the desktop environment
    xdg.icons.enable = true;

    # Enable xdg-desktop-portal support
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
    };
    environment.systemPackages = with pkgs; [ xclip ];
  };
}
