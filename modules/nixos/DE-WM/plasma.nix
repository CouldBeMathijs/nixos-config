{ pkgs, lib, config, ...}:
{
        options = {
                plasma.enable = lib.mkEnableOption "enable plasma.nix";
        };

        config = lib.mkIf config.plasma.enable {

                services.xserver.enable = true;
                services.gvfs.enable = true;
                services.desktopManager.plasma6.enable = true;
                services.displayManager.sddm.enable = true;

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
