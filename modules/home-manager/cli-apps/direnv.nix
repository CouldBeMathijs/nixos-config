{ pkgs, lib, config, options, ... }:
{
        options = {
                nix-direnv.enable = lib.mkEnableOption "Enable direnv configuration";
        };

        config = lib.mkIf config.nix-direnv.enable {
                programs.direnv = {
                        enable = true;
                        enableBashIntegration = true; # see note on other shells below
                        nix-direnv.enable = true;
                };
                home.packages = with pkgs; [ direnv nix-direnv ];
        };
}
