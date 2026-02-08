{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "plasma";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    services.xserver.enable = true;
    services.gvfs.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
    sddm-minimal-theme.enable = lib.mkDefault true;

    services.xserver.excludePackages = with pkgs; [
      xterm # Exclude the basic xterm terminal
    ];

    xdg.icons.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        kdePackages.xdg-desktop-portal-kde
      ];
    };

    environment.systemPackages = with pkgs; [
      kdePackages.kate
      kdePackages.dolphin
    ];
  };
}
