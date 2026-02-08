{
  lib,
  config,
  ...
}:
let
  name = "fwupd";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    services.fwupd = {
      enable = true;
    };
  };
}
