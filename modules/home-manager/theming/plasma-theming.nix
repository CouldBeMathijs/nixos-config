{ lib, config, pkgs, gruvbox-plus-icons-git, ... }:
let
        wallpaperPath = ./images/bulbs.png;
in
        {
        options = {
                plasma-theming.enable = lib.mkEnableOption "enable plasma-theming";
        };

        config = lib.mkIf config.plasma-theming.enable {
                # 1. Ensure the icon package is actually installed
                home.packages = [
                        gruvbox-plus-icons-git
                ];
                gtk = {
                        enable = true;

                        theme = {
                                name = "Breeze-Dark";
                                package = pkgs.kdePackages.breeze-gtk;
                        };

                        gtk3.extraConfig = {
                                gtk-application-prefer-dark-theme = 1;
                        };

                        gtk4.extraConfig = {
                                gtk-application-prefer-dark-theme = 1;
                        };
                };
                programs.plasma = {
                        enable = true;
                        overrideConfig = true; # Warning: This wipes manual changes on every switch

                        workspace = {
                                # 2. Use lookAndFeel to force the global "Dark" profile
                                lookAndFeel = "org.kde.breezedark.desktop";
                                theme = "breeze-dark";

                                # 3. Double check this name matches the folder in the package
                                iconTheme = "Gruvbox-Plus-Dark"; 

                                wallpaper = wallpaperPath;
                        };

                        kscreenlocker.appearance.wallpaper = wallpaperPath;

                        kwin = {
                                titlebarButtons.left = [ "close" "minimize" "maximize" ];
                                titlebarButtons.right = [ "keep-above-windows" ];
                        };

                };
        };
}
