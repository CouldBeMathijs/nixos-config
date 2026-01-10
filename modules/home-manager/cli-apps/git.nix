{ pkgs, lib, config, ... }:
{
        options = {
                git.enable = lib.mkEnableOption "Enable git configuration";
        };

        config = lib.mkIf config.git.enable {
                # Git configuration
                programs.git = {
                        enable = true;
                        settings = {
                                user = {
                                        name = "Mathijs";
                                        email = "79464596+CouldBeMathijs@users.noreply.github.com";
                                };
                                init.defaultBranch = "main";
                        };
                };
                home.packages = with pkgs; [
                        gh # Github client
                        git # Duh
                        git-filter-repo
                ];
        };
}
