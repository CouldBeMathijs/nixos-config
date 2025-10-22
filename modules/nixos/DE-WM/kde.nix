{ pkgs, lib, config, ...}:
{
  options = {
    kde.enable = lib.mkEnableOption "enable kde.nix";
  };
  
  config = lib.mkIf config.kde.enable {
    
    # 1. Corrected X Server and Desktop/Display Manager Configuration
    services.xserver.enable = true;
    
    # WARNING FIXES: Use the new, un-nested options for plasma6 and sddm
    # Old: services.xserver.desktopManager.plasma6.enable = true;
    # Old: services.xserver.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
    
    # Exclude packages that are often included by default but might be redundant
    services.xserver.excludePackages = with pkgs; [
      xterm # Exclude the basic xterm terminal
    ];
    
    # 2. XDG and Portals (Essential for modern desktop integration)
    xdg.icons.enable = true;
    xdg.portal = {
      enable = true;
      # Explicitly use the Qt 6 (Plasma 6) version of the portal
      extraPortals = with pkgs; [
        xdg-desktop-portal
        kdePackages.xdg-desktop-portal-kde 
      ];
    };

    # 3. System Packages (Minimal additions, with the error fix)
    environment.systemPackages = with pkgs; [
      # ERROR FIX: Explicitly use kdePackages.kate as the top-level alias is removed.
      kdePackages.kate 
      # dolphin is also explicitly added using the modern set for consistency
      kdePackages.dolphin 
    ];
  };
}
