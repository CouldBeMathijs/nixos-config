{
  lib,
  config,
  ...
}:
let
  name = "tailscale";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };
  };
}
