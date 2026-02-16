{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "plasma-apps";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # kdePackages.kdenlive # Video editor
      devtoolbox # Just some nicities
      gtranslator # PO translation editor
      karp # Pdf page editor
      kdePackages.dragon # Video player
      kdePackages.elisa # Music player
      kdePackages.filelight # Disk Usage Analyser
      kdePackages.isoimagewriter # dd but Gnome
      kdePackages.kapman # Pacman in all but name
      kdePackages.kbreakout
      kdePackages.kolourpaint # Paint
      kdePackages.konquest
      kdePackages.okular # Pdf reader
      krename # Bulk rename tol
      media-downloader # A, you will not believe this, media downloader
      qalculate-qt # Calculator
      rnote # Handdrawn note taking
    ];
    environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
      lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0"
        [
          pkgs.gst_all_1.gst-plugins-bad
          pkgs.gst_all_1.gst-plugins-good
          pkgs.gst_all_1.gst-plugins-ugly
        ];
  };
}
