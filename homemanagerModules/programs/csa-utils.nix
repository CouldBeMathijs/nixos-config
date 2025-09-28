{ pkgs, lib, config, options, ... }:
{
        options = {
                csa-utils.enable = lib.mkEnableOption "Enable csa-utils configuration";
        };

        config = lib.mkIf config.csa-utils.enable {
                home.packages = with pkgs; [
                        logisim # Live laugh Logisim - Swiepie (2024)
                        mars-mips # MIPS Assembly IDE
                ];
        };
}
