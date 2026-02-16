{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "cn-utils";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      mininet
      wireshark
    ];
  };
}
