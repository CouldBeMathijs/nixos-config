{
  lib,
  config,
  pkgs,
  gruvbox-plus-icons-git,
  ...
}:
{
  options.niri-config = {
    enable = lib.mkEnableOption "Enable niri-config configuration";
  };

  config = lib.mkIf config.niri-config.enable {
    programs.noctalia = {
      enable = true;
    };
    home.packages = [ gruvbox-plus-icons-git ];

    gtk = {
      enable = true;
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
      };
    };

    xdg.configFile."niri/config.kdl".source = ../../../kdl/config.kdl;
    xdg.configFile."niri/noctalia.kdl".source = ../../../kdl/noctalia.kdl;
  };
}
