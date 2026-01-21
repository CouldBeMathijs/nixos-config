{
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  fortuneWithOffensive = pkgs.fortune.override { withOffensive = true; };
in
{
  options = {
    fun-cli.enable = lib.mkEnableOption "Enable fun-cli configuration";
  };

  config = lib.mkIf config.fun-cli.enable {
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
