{ pkgs, lib, config, ...}: {
        options = {
                gnome-apps.enable = lib.mkEnableOption "enable gnome-apps.nix";
        };
        config = lib.mkIf config.gnome-apps.enable {
                environment.systemPackages = with pkgs; [ 
                        amberol # Music player
                        clapper # Video player
                        devtoolbox # Just some nicities
                        fractal # Matrix client
                        impression # dd but Gnome
                        parabolic # Media downloader
                        papers # Pdf reader
                        pinta # Paint
                        pdfarranger # Pdf arranger
                        pitivi # Video editor
                        rnote # Handdrawn note taking
                        gtranslator # PO translation editor
                        # Games
                        quadrapassel # Tetris in all but name
                        gnome-nibbles # Snake++
                ];
                environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
                        pkgs.gst_all_1.gst-plugins-good
                        pkgs.gst_all_1.gst-plugins-bad
                        pkgs.gst_all_1.gst-plugins-ugly
                ];
        };
}
