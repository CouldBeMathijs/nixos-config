{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    printing.enable = lib.mkEnableOption "enable printing.nix";
  };
  config = lib.mkIf config.printing.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    services.printing = {
      enable = true;
      drivers = [
        pkgs.epson-escpr
        pkgs.epson-escpr2
        pkgs.epson_201207w
      ];
    };
    # Extra printer stuff
    hardware.sane = {
      enable = true;
      extraBackends = [
        pkgs.sane-airscan
      ];
    };
    services.udev.packages = [
      pkgs.sane-airscan
    ];
  };
}
