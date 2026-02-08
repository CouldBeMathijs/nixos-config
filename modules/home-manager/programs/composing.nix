{
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  name = "composing";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

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
