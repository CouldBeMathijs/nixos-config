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
                        # Games
                        quadrapassel # Tetris in all but name
                        gnome-nibbles # Snake++
                ];
        };
}
