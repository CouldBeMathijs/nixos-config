{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.niri-config = {
    enable = lib.mkEnableOption "Enable niri-config configuration";
  };

  config = lib.mkIf config.niri-config.enable {

    programs.noctalia = {
      enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
        };
      };
    };
    xdg.configFile."niri/config.kdl".text = ''
      spawn-at-startup "${pkgs.noctalia}/bin/noctalia"
    '';
  };
}
