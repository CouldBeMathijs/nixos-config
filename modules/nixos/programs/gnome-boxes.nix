{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "gnome-boxes";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gnome-boxes ];
  };
}
