{ lib, config, pkgs, gruvbox-plus-icons-git, ... }:
let
        wallpaperPath = /home/mathijs/.dotfiles/images/bulbs.jpg;
in
        {
        options = {
                plasma-theming.enable = lib.mkEnableOption "enable plasma-theming";
        };

        config = lib.mkIf config.plasma-theming.enable {
                home.packages = [
                        gruvbox-plus-icons-git
                ];
                gtk = {
                        enable = true;
                        gtk2.enable = false;
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
                                iconTheme = "Gruvbox-Plus-Dark"; 
                                lookAndFeel = "org.kde.breezedark.desktop";
                                theme = "breeze-dark";
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
