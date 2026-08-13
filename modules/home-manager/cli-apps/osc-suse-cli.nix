{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "osc-suse-cli";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      python3Packages.osc
    ];
  };
}
