{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    jellyfin.enable = lib.mkEnableOption "Enable Jellyfin media server";
  };

  config = lib.mkIf config.jellyfin.enable {
    services.jellyfin.enable = true;

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };
}
