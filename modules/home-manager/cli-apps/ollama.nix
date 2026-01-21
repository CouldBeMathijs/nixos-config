{ pkgs, lib, config, options, ... }:
{
        options = {
                ollama.enable = lib.mkEnableOption "Enable ollama configuration";
        };

        config = lib.mkIf config.ollama.enable {
                home.packages = [
                        pkgs.ollama
                ];
        };
}
