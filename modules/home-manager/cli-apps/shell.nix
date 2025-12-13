{ pkgs, lib, config, microfetch, ... }:
let
        flake = "${config.home.homeDirectory}/.dotfiles";
in
        {
        options = {
                shell.enable = lib.mkEnableOption "enable shell";
        };

        config = lib.mkIf config.shell.enable {
                home.packages = [
                        microfetch.microfetch # Nix specific fetcher, as fast as can be
                        pkgs.atuin # Better up arrow
                        pkgs.bat # Better cat
                        pkgs.eza # Better ls
                        pkgs.tldr # When man is overkill
                        pkgs.trash-cli # rm on safe mode
                        pkgs.zoxide # cd^2
                ];
                # Shell configuration
                programs.bash = {
                        enable = true;
                        initExtra = "microfetch";
                        shellAliases = {
                                ".." = "cd ..";
                                "cat" = "bat";
                                "clear" = "clear; microfetch";
                                "ll" = "eza -l";
                                "ls" = "eza";
                                "open" = "xdg-open";
                                "switch-all" = "nh os switch ${flake} && home-manager switch --print-build-logs --verbose --flake ${flake} && nh clean user --keep-since 3d --keep 5";
                                "switch-home" = "home-manager switch --print-build-logs --verbose --flake ${flake} && nh clean user --keep-since 3d --keep 5";
                                "z" = "zoxide";
                        };
                };
                programs = {
                        atuin = {
                                enable = true;
                        };
                        zoxide = {
                                enable = true;
                                enableBashIntegration = true;
                        };
                };
                xdg = {
                        enable = true;
                        desktopEntries."btop" = {
                                name = "btop++";
                                noDisplay = true;
                        };
                };
        };
}
