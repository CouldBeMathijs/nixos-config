{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "restic-server";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable Restic REST server";
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/restic";
      description = "Where to store the backup data.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.restic.rest-server = {
      enable = true;
      dataDir = cfg.dataDir;
      extraFlags = [ "--no-auth" ]; # Use this only in a secure local network
      listenAddress = "8000";
    };

    # Open the firewall for the REST server
    networking.firewall.allowedTCPPorts = [ 8000 ];
  };
}
