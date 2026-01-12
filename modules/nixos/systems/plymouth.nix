{ pkgs, lib, config, ...}:
let
        selectedTheme = "hexagon_2";
in
        {
        options = {
                plymouth.enable = lib.mkEnableOption "enable plymouth.nix";
        };

        config = lib.mkIf config.plymouth.enable {
                boot = {
                        plymouth = {
                                enable = true;
                                theme = selectedTheme; 
                                themePackages = with pkgs; [
                                        (adi1090x-plymouth-themes.override {
                                                selected_themes = [ selectedTheme ]; 
                                        })
                                ];
                        };

                        # Enable "Silent boot"
                        consoleLogLevel = 3;
                        initrd.verbose = false;
                        kernelParams = [
                                "quiet"
                                "splash"
                                "boot.shell_on_fail"
                                "udev.log_priority=3"
                                "rd.systemd.show_status=auto"
                        ];

                        # Hide the OS choice for bootloaders.
                        # It's still possible to open the bootloader list by pressing any key
                        # It will just not appear on screen unless a key is pressed
                        loader.timeout = 0;
                };
        };
}
