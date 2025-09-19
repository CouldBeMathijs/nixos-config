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
                # Enable shell.nix
                shell.enable = true;
                # Enable fastfetch.nix
                fastfetch.enable = true;
                # Enable gnome customization
                gnome-extensions.enable = true;
                gnome-theming.enable = true;

                home.homeDirectory = "/home/mathijs";
                home.username = "mathijs";
                # This value determines the Home Manager release that your configuration is
                # compatible with.
                home.stateVersion = "25.05"; # Do not change unless you know what you are doing!
                home.packages = [
                        (pkgs.gramps.overrideAttrs (oldAttrs: {
                                src = pkgs.fetchFromGitHub {
                                        owner = "gramps-project";
                                        repo = "gramps";
                                        rev = "v6.0.4";
                                        hash = "sha256-MBsc4YMbCvzRG6+7/cGQpx7iYvQAdqWYrIMEpf1A7ew=";
                                };
                                version = "6.0.4";

                                propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
                                        pkgs.python3Packages.orjson
                                ];

                                patches = builtins.filter (p:
                                        let
                                                patchName = builtins.toString p;
                                                suffix = "disable-gtk-warning-dialog.patch";
                                        in
                                                builtins.substring (builtins.stringLength patchName - builtins.stringLength suffix) (builtins.stringLength suffix) patchName != suffix
                                ) oldAttrs.patches;
                        }))
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
                                "muse-sounds-manager" = {
                                        name = "Muse Sounds Manager";
                                        icon = "enjoy-music-player";
                                        comment = "Manage Muse sound themes";
                                        exec = "muse-sounds-manager";
                                        categories = [ "Audio" ];
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
