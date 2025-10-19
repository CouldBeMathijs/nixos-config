{ pkgs, lib, config, options, ... }:
let
        fortuneWithOffensive = pkgs.fortune.override { withOffensive = true; };
in
        {
        options = {
                funCli.enable = lib.mkEnableOption "Enable funCli configuration";
        };

        config = lib.mkIf config.funCli.enable {
                home.packages = with pkgs; [
                        pipes
                        fortuneWithOffensive
                        cowsay
                        cmatrix
                        cava
                        lolcat
                ];
        };
}
