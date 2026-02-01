{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.ssh.enable = lib.mkEnableOption "Enable openssh";

  config = lib.mkIf config.ssh.enable {
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
