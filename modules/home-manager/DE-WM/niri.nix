{
  pkgs,
  lib,
  config,
  options,
  niri,
  ...
}:
{
  options = {
    niri-config.enable = lib.mkEnableOption "Enable niri-config configuration";
  };

  config = lib.mkIf config.niri-config.enable {
    /*
      home.packages = with pkgs; [
        fuzzel
        waybar
      ];

      nixpkgs.overlays = [ niri.overlays.niri ];
      programs.niri.settings = {
        # Basic keybindings
        binds = {
          "Mod+T".action.spawn = "ghostty";
          "Mod+Space".action.spawn = "fuzzel";
          "Mod+Q".action.close-window = [ ];
        };

        # Startup applications
        spawn-at-startup = [
          { command = [ "waybar" ]; }
          { command = [ "fuzzel" ]; }
        ];
      };
    */
  };
}
