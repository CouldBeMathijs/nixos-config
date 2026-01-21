{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    # The master switch to enable or disable all ripping functionality
    ripping.enable = lib.mkEnableOption "enable disc ripping functionality";

    # Options for specific types of ripping
    ripping.cd.enable = lib.mkEnableOption "enable CD ripping packages";
    ripping.dvd.enable = lib.mkEnableOption "enable DVD ripping packages";
  };

  config = lib.mkIf config.ripping.enable {

    ripping.cd.enable = lib.mkDefault true;
    ripping.dvd.enable = lib.mkDefault true;

    environment.systemPackages =
      lib.optionals config.ripping.cd.enable [
        pkgs.sound-juicer
      ]
      ++ lib.optionals config.ripping.dvd.enable [
        pkgs.libdvdcss
        pkgs.handbrake
        pkgs.makemkv
      ];
  };
}
