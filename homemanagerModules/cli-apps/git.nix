{ pkgs, lib, config, options, ... }:
{
        options = {
                git.enable = lib.mkEnableOption "Enable git configuration";
        };

        config = lib.mkIf config.git.enable {
                # Git configuration
                programs.git = {
                        enable = true;
                        userName = "Mathijs";
                        userEmail = "79464596+CouldBeMathijs@users.noreply.github.com";
                        extraConfig = {
                                init.defaultBranch = "main";
                        };
                };
                home.packages = with pkgs; [
                        gh # Github client
                        git # Duh
                ];
        };
}
