{ pkgs, lib, config, options, ... }:
{
        options = {
                dosbox.enable = lib.mkEnableOption "Enable dosbox configuration";
        };

        config = lib.mkIf config.dosbox.enable {
                home.packages = with pkgs; [
                        dosbox
                ];
        };
}
