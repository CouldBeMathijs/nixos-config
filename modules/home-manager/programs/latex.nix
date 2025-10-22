{ pkgs, lib, config, options, ... }:
{
        options = {
                latex.enable = lib.mkEnableOption "Enable latex configuration";
        };

        config = lib.mkIf config.latex.enable {
                home.packages = with pkgs; [
                        setzer # LaTeX, the editor
                        texliveMedium # LaTeX, the language
                ];
        };
}
