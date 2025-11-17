{ pkgs, lib, config, options, ... }:
{
        options = {
                niri-config.enable = lib.mkEnableOption "Enable niri-config configuration";
        };

        config = lib.mkIf config.niri-config.enable {
                home.packages = with pkgs; [
                        fuzzel
                        waybar
                ];
        };
}
