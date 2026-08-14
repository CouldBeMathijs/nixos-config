{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "niri";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      nautilus
      cifs-utils
      samba
    ];
    services = {
      gvfs.enable = true;
      gnome.gnome-keyring.enable = true;
      samba-wsdd.enable = true;
    };
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
  };
}
