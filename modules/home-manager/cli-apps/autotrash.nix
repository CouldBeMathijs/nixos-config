{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "autotrash";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.autotrash ];

    systemd.user.services.autotrash = {
      Unit.Description = "Automatically clean trash files older than 30 days";
      Service.ExecStart = "${pkgs.autotrash}/bin/autotrash -d 30";
    };

    systemd.user.timers.autotrash = {
      Unit.Description = "Run autotrash daily";
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
