{ pkgs-stable, lib, config, ... }:
{
        options = {
                discord.enable = lib.mkEnableOption "Enable discord configuration";
        };

        config = lib.mkIf config.discord.enable {
                home.packages = with pkgs-stable; [
                        vesktop # My discord client of choice
                ];
                xdg = {
                        enable = true;
                        desktopEntries."vesktop" = {
                                name = "Vesktop";
                                comment = "A Discord client";
                                genericName = "Discord Client";
                                exec = "vesktop";
                                type = "Application";
                                icon = "discord";
                        };
                        autostart = {
                                enable = true;
                                entries = [ "${config.home.homeDirectory}/.nix-profile/share/applications/vesktop.desktop" ];
                        };
                };

        };
}
