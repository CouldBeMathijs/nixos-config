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
        texliveMedium # Always installed if latex.enable is true
      ]
      ++ (if config.gnome-theming.enable then [ setzer ] else [ texmaker ]);
  };
}
