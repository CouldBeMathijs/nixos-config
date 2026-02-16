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
    environment.systemPackages = with pkgs; [
      mininet
      wireshark
    ];
  };
}
