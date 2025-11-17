{ pkgs, lib, config, ... }:
let
        flake = "${config.home.homeDirectory}/.dotfiles";
in
        {
        options = {
                shell.enable = lib.mkEnableOption "enable shell";
        };

        config = lib.mkIf config.shell.enable {
                home.packages = with pkgs; [
                        bat # Better cat
                        eza # Better ls
                        microfetch # Nix specific fetcher, as fast as can be
                        tldr # When man is overkill
                        trash-cli # rm on safe mode
                        zoxide # cd^2
                ];
                # Shell configuration
                programs.bash = {
                        enable = true;
                        initExtra = "microfetch";
                        shellAliases = {
                                ".." = "cd ..";
                                "cat" = "bat";
                                "clear" = "clear; fastfetch";
                                "ll" = "eza -l";
                                "ls" = "eza";
                                "open" = "xdg-open";
                                "switch-all" = "nh os switch ${flake} && home-manager switch --print-build-logs --verbose --flake ${flake} && nh clean user --keep-since 3d --keep 5";
                                "switch-home" = "home-manager switch --print-build-logs --verbose --flake ${flake} && nh clean user --keep-since 3d --keep 5";
                                "z" = "zoxide";
                        };
                };
                programs.zoxide = {
                        enable = true;
                        enableBashIntegration = true;
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
