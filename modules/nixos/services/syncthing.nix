{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "syncthing";
  cfg = config.${name};
  syncthingPowerScript = pkgs.writeShellScript "syncthing-power" ''
    API_KEY=$(cat /etc/syncthing-api-key)
    URL="http://127.0.0.1:8384/rest/system"

    case "$1" in
      pause)
        ${pkgs.curl}/bin/curl -s -X POST -H "X-API-Key: $API_KEY" "$URL/pause"
        ;;
      resume)
        ${pkgs.curl}/bin/curl -s -X POST -H "X-API-Key: $API_KEY" "$URL/resume"
        ;;
    esac
  '';
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    services.syncthing.enable = true;

    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${syncthingPowerScript} pause"
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${syncthingPowerScript} resume"
    '';
  };
}
