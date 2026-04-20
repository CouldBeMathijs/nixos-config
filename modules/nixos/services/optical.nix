{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.optical;
in
{
  options.optical = {
    enable = lib.mkEnableOption "Enable all optical drive tooling";
    burning.enable = lib.mkEnableOption "optical disc burning tools (K3b)";

    ripping = {
      enable = lib.mkEnableOption "all disc ripping functionality";
      cd.enable = lib.mkEnableOption "CD ripping packages";
      dvd.enable = lib.mkEnableOption "DVD ripping packages";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      optical.ripping.enable = lib.mkDefault true;
      optical.burning.enable = lib.mkDefault true;
    })
    # Logic for the Ripping Master Switch
    (lib.mkIf cfg.ripping.enable {
      optical.ripping.cd.enable = lib.mkDefault true;
      optical.ripping.dvd.enable = lib.mkDefault true;
    })

    # Package and System Configuration
    (lib.mkIf (cfg.ripping.cd.enable || cfg.ripping.dvd.enable || cfg.burning.enable) {

      # Always load kernel module and udev rules if any optical feature is active
      boot.kernelModules = [ "sg" ];
      services.udev.extraRules = ''
        KERNEL=="sr[0-9]*", GROUP="burning", MODE="0660"
      '';

      environment.systemPackages =
        lib.optionals cfg.ripping.cd.enable [
          pkgs.sound-juicer
        ]
        ++ lib.optionals cfg.ripping.dvd.enable [
          pkgs.libdvdcss
          pkgs.handbrake
          pkgs.makemkv
        ]
        ++ lib.optionals cfg.burning.enable [ pkgs.devede ];

      # Burning specific configuration
      programs.k3b.enable = cfg.burning.enable;
    })
  ];
}
