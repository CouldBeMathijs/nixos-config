{
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  name = "fun-cli";
  cfg = config.${name};
  fortuneWithOffensive = pkgs.fortune.override { withOffensive = true; };
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
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
