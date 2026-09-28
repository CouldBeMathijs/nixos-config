{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "zen-browser";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      zen-browser
    ];
    xdg = {
      enable = true;
      desktopEntries = {
        "zen-beta" = {
          name = "Zen Browser";
          genericName = "Web Browser";
          comment = "A web browser based on Zen";
          exec = "zen-beta %U";
          icon = "zen-browser";
          terminal = false;
          type = "Application";
          mimeType = [
            "text/html"
            "text/xml"
            "application/pdf"
            "application/xhtml+xml"
            "application/vnd.mozilla.xul+xml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];
          categories = [
            "Network"
            "WebBrowser"
          ];
          startupNotify = true;
        };
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "zen-beta.desktop";
          "application/x-extension-htm" = "zen-beta.desktop";
          "application/x-extension-html" = "zen-beta.desktop";
          "application/x-extension-shtml" = "zen-beta.desktop";
          "application/x-extension-xht" = "zen-beta.desktop";
          "application/x-extension-xhtml" = "zen-beta.desktop";
          "application/xhtml+xml" = "zen-beta.desktop";
          "text/html" = "zen-beta.desktop";
          "x-scheme-handler/chrome" = "zen-beta.desktop";
        };
      };
    };
  };

}
