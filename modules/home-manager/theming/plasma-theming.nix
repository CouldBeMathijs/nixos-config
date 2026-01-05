{ lib, config, pkgs, gruvbox-plus-icons-git, ... }:
let
        wallpaperPath = /home/mathijs/.dotfiles/images/bulbs.jpg;
        geometryChange = pkgs.callPackage ../../../packages/kwin-script-geometry-change.nix {};
in
{
        options = {
                plasma-theming.enable = lib.mkEnableOption "enable plasma-theming";
        };

        config = lib.mkIf config.plasma-theming.enable {
                home.packages = [ 
                        geometryChange
                        gruvbox-plus-icons-git
                        pkgs.kdePackages.karousel
                ];

                gtk = {
                        enable = true;
                        gtk2.enable = false;
                        theme = {
                                name = "Breeze-Dark";
                                package = pkgs.kdePackages.breeze-gtk;
                        };
                        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
                        gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
                };

                programs.plasma = {
                        enable = true;
                        overrideConfig = true;
                        input = {
                                keyboard.layouts = [
                                {
                                        displayName = "usi";
                                        layout = "us";
                                        variant = "intl";
                                }
                                ];
                        };
                        workspace = {
                                iconTheme = "Gruvbox-Plus-Dark";
                                lookAndFeel = "org.kde.breezedark.desktop";
                                theme = "breeze-dark";
                                wallpaper = wallpaperPath;
                        };
                        configFile = {
                                kwinrc = {
                                        Plugins = {
                                                karouselEnabled = true;
                                                kwin4_effect_geometry_changeEnabled = true;
                                        };
                                        Script-karousel = {
                                                gestureScroll = true;
                                                gestureScrollInvert = true;
                                        };
                                };
                        };
                        kscreenlocker.appearance.wallpaper = wallpaperPath;

                        kwin = {
                                titlebarButtons.left = [ "close" "minimize" "maximize" ];
                                titlebarButtons.right = [ "keep-above-windows" ];
                        };
                        panels = [
                        # Bottom Panel (Centered Icon Tasks)
                        {
                                location = "bottom";
                                height = 56;
                                floating = true;
                                hiding = "dodgewindows";
                                widgets = [
                                        "org.kde.plasma.panelspacer"
                                        {
                                                name = "org.kde.plasma.icontasks";
                                                config = {
                                                        General = {
                                                                # List the .desktop files for the apps you want to pin
                                                                launchers = [
                                                                                "applications:zen-beta.desktop"
                                                                                "applications:org.kde.konsole.desktop"
                                                                                "applications:org.kde.dolphin.desktop"
                                                                                "applications:vesktop.desktop"
                                                                ];
                                                        };
                                                };
                                        }
                                "org.kde.plasma.panelspacer"
                                ];
                        }
                        # Top Panel
                        {
                                location = "top";
                                height = 30;
                                floating = true;
                                widgets = [
                                {
                                        name = "org.kde.plasma.kicker";
                                        config = {
                                                General = {
                                                        icon = "distributor-logo-nixos";
                                                        systemFavorites = "suspend\\,hibernate\\,reboot\\,shutdown";
                                                        favoritesPortedToKAstats = true;
                                                };
                                                Configuration = {
                                                        PreloadWeight = 100;
                                                        popupHeight = 440;
                                                        popupWidth = 300;
                                                };
                                        };
                                }
                                "org.kde.plasma.pager"
                                        "org.kde.plasma.panelspacer"
                                        "org.kde.plasma.digitalclock"
                                        "org.kde.plasma.panelspacer"
                                        "org.kde.plasma.systemtray"
                                        "org.kde.plasma.showdesktop"
                                        ];
                        }
                        ];
                };
        };
}
