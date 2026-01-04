{ lib, config, pkgs, gruvbox-plus-icons-git, ... }:
let
        wallpaperPath = /home/mathijs/.dotfiles/images/bulbs.jpg;
in
        {
        options = {
                plasma-theming.enable = lib.mkEnableOption "enable plasma-theming";
        };

        config = lib.mkIf config.plasma-theming.enable {
                home.packages = [ gruvbox-plus-icons-git ];

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

                        panels = [
                                # Bottom Panel (Centered Icon Tasks)
                                {
                                        location = "bottom";
                                        height = 56;
                                        floating = true;
                                        hiding = "dodgewindows";
                                        widgets = [
                                                "org.kde.plasma.panelspacer" # Modern Spacer
                                                "org.kde.plasma.icontasks"
                                                "org.kde.plasma.panelspacer" # Modern Spacer
                                        ];
                                }
                                # Top Panel
                                {
                                        location = "top";
                                        height = 30;
                                        floating = true;
                                        widgets = [
                                                "org.kde.plasma.kickoff"
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
