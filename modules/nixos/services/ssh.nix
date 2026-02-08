{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "ssh";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ openssh ];
    services = {
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
        };
      };
      fail2ban = {
        enable = true;
      };
    };
  };
}
