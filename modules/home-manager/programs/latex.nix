{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.latex = {
    enable = lib.mkEnableOption "Enable latex configuration";
  };

  config = lib.mkIf config.latex.enable {
    home.packages =
      with pkgs;
      [
        texliveFull
      ]
      ++ (
        if config.gnome-config.enable then
          [ setzer ]
        else if config.plasma-config.enable then
          [ kile ]
        else
          [ texmaker ]
      );
  };
}
