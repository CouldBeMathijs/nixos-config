{ config, pkgs, ... }:

{
        # Home Manager needs a bit of information about you and the paths it should
        # manage.

        imports = [
                ../../modules/home-manager
        ];

        config = {
                # Enable shell configuration
                shell.enable = true;

                # Enable fastfetct configuration
                fastfetch.enable = true;

                #gnome-theming.enable = true;
                #gnome-extensions.enable = true;

                # Enable musescore
                composing.enable = false;
                gramps.enable = true;
                minecraft.enable = true;
                discord.enable = true;

                home.homeDirectory = "/home/mathijs";
                home.username = "mathijs";
                # This value determines the Home Manager release that your configuration is
                # compatible with.
                home.stateVersion = "25.05"; # Do not change unless you know what you are doing!
                home.packages = with pkgs; [
                        signal-desktop
                        libreoffice-fresh
                ];

                xdg = {
                        enable = true;
                        desktopEntries = {
                                "cups" = {
                                        name = "Cups Printer Manager";
                                        noDisplay = true;
                                };
                                "com.mitchellh.ghostty" = {
                                        name = "Ghostty";
                                        genericName = "Terminal Emulator";
                                        comment = "A terminal emulator";
                                        exec = "ghostty";
                                        icon = "terminal";
                                        categories = [ "System" "TerminalEmulator" ];
                                        startupNotify = true;
                                        terminal = false;
                                        actions = {
                                                new-window = {
                                                        name = "New Window";
                                                        exec = "ghostty";
                                                };
                                        };
                                };
                        };
                };
                # Ghostty terminal configuration
                programs.ghostty = {
                        enable = true;
                        enableBashIntegration = true;
                        installBatSyntax = true;
                        settings = {
                                theme = "Gruvbox Dark Hard";
                        };
                };

                # Let Home Manager install and manage itself.
                programs.home-manager.enable = true;
        };
}
