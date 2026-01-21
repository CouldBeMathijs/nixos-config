{
  pkgs,
  lib,
  config,
  options,
  ...
}:
{
  options = {
    composing.enable = lib.mkEnableOption "Enable composing configuration";
  };

  config = lib.mkIf config.composing.enable {
    home.packages = with pkgs; [
      musescore # Writing music scores
      muse-sounds-manager # Write music scores with better playback
    ];
    xdg.enable = true;
    xdg.desktopEntries."muse-sounds-manager" = {
      name = "Muse Sounds Manager";
      icon = "enjoy-music-player";
      comment = "Manage Muse sound themes";
      exec = "muse-sounds-manager";
      categories = [ "Audio" ];
    };
  };
}
