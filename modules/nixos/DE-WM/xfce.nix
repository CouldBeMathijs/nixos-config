{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    xfce.enable = lib.mkEnableOption "Enable xfce desktop environment";
  };

  config = lib.mkIf config.xfce.enable {
    services.xserver = {
      enable = true;

      # Use LightDM as the display manager
      displayManager.lightdm.enable = true;

      # Enable xfce desktop
      desktopManager.xfce.enable = true;

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
