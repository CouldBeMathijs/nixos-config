{ pkgs, lib, config, ... }:
{
        options.latex = {
                enable = lib.mkEnableOption "Enable latex configuration";

                gnome-apps = lib.mkOption {
                        type = lib.types.bool;
                        default = false;
                        description = "If true, use Setzer (GNOME); otherwise, use Texmaker.";
                };
        };

        config = lib.mkIf config.latex.enable {
                home.packages = with pkgs; [
                        texliveMedium # Always installed if latex.enable is true
                ] ++ (if config.latex.gnome-apps then [ setzer ] else [ texmaker ]);
        };
}
