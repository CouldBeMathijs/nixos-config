{ pkgs, lib, config, ...}: {
        options = {
                plasma-apps.enable = lib.mkEnableOption "enable plasma-apps.nix";
        };
        config = lib.mkIf config.plasma-apps.enable {
                environment.systemPackages = with pkgs; [ 
                        kdePackages.elisa # Music player
                        kdePackages.dragon # Video player
                        devtoolbox # Just some nicities
                        # kdePackages.neochat # Matrix client
                        kdePackages.isoimagewriter # dd but Gnome
                        parabolic # Media downloader
                        kdePackages.okular # Pdf reader
                        kdePackages.kolourpaint # Paint
                        pdfarranger # Pdf arranger
                        pitivi # Video editor
                        rnote # Handdrawn note taking
                        gtranslator # PO translation editor
                        # Games
                        kdePackages.kapman # Pacman in all but name
                        kdePackages.kbreakout
                        kdePackages.konquest
                ];
                environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
                        pkgs.gst_all_1.gst-plugins-good
                        pkgs.gst_all_1.gst-plugins-bad
                        pkgs.gst_all_1.gst-plugins-ugly
                ];
        };
}
