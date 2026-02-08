{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "xfce";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
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
