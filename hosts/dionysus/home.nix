{ config, pkgs, ... }:

#let
#mars-mips-icon-file = pkgs.runCommand "mars-mips-icon-file" { } ''
#mkdir -p $out/
#cp ${./images/mars-mips.png} $out/mars-mips.png
#'';

#in
{
        # Home Manager needs a bit of information about you and the paths it should
        # manage.

        imports = [
                ../../homemanagerModules
        ];

        config = {
                # Enable shell configuration
                shell.enable = true;
                
                # Enable fastfetct configuration
                fastfetch.enable = true;

                # Enable cinnamon theming
                #cinnamon-theming.enable = true;
                gnome-theming.enable = true;
                gnome-extensions.enable = true;

                # Enable musescore
                composing.enable = true;
                gramps.enable = true;
                minecraft.enable = true;

                home.homeDirectory = "/home/mathijs";
                home.username = "mathijs";
                # This value determines the Home Manager release that your configuration is
                # compatible with.
                home.stateVersion = "25.05"; # Do not change unless you know what you are doing!
                home.packages = with pkgs; [
                        # Messaging apps
                        signal-desktop
                        vesktop
                ];

                xdg = {
                        enable = true;
                        autostart = {
                                enable = true;
                                entries = [ "${config.home.homeDirectory}/.nix-profile/share/applications/vesktop.desktop" ];
                        };
                        
                        desktopEntries = {
                                "cups" = {
                                        name = "Cups Printer Manager";
                                        noDisplay = true;
                                };
                                #"mars" = {
                                #name = "Mars MIPS";
                                #categories = [ "Development" "IDE" ];
                                #comment = "IDE for programming in MIPS assembly language intended for educational-level use";
                                #genericName = "MIPS Editor";
                                #exec = "Mars";
                                #type = "Application";
                                #icon = "${mars-mips-icon-file}/mars-mips.png";
                                #};
                                "vesktop" = {
                                        name = "Vesktop";
                                        comment = "A Discord client";
                                        genericName = "Discord Client";
                                        exec = "vesktop";
                                        type = "Application";
                                        icon = "discord";
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
                                theme = "GruvboxDarkHard";
                        };
                };

                # Let Home Manager install and manage itself.
                programs.home-manager.enable = true;
        };
}
