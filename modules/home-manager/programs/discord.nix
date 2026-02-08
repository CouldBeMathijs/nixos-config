{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "discord";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vesktop # My discord client of choice
    ];
    xdg = {
      enable = true;
      desktopEntries."vesktop" = {
        name = "Vesktop";
        comment = "A Discord client";
        genericName = "Discord Client";
        exec = "vesktop";
        type = "Application";
        icon = "discord";
      };
      autostart = {
        enable = true;
        entries = [ "${config.home.homeDirectory}/.nix-profile/share/applications/vesktop.desktop" ];
      };
    };

  };
}
