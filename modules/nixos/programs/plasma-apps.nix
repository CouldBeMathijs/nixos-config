{ pkgs, lib, config, ...}: {
        options = {
                plasma-apps.enable = lib.mkEnableOption "enable plasma-apps.nix";
        };
        config = lib.mkIf config.plasma-apps.enable {
                environment.systemPackages = with pkgs; [ 
                        devtoolbox # Just some nicities
                        gtranslator # PO translation editor
                        kdePackages.dragon # Video player
                        kdePackages.elisa # Music player
                        kdePackages.isoimagewriter # dd but Gnome
                        kdePackages.kapman # Pacman in all but name
                        kdePackages.kbreakout
                        kdePackages.kolourpaint # Paint
                        kdePackages.konquest
                        kdePackages.okular # Pdf reader
                        krename # Bulk rename tol
                        parabolic # Media downloader
                        pdfarranger # Pdf arranger
                        pitivi # Video editor
                        rnote # Handdrawn note taking
                ];
                environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
                        pkgs.gst_all_1.gst-plugins-bad
                        pkgs.gst_all_1.gst-plugins-good
                        pkgs.gst_all_1.gst-plugins-ugly
                ];
        };
}
