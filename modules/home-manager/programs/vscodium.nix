{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "vscodium";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.vscodium = {
      enable = true;
      package = pkgs.vscodium.fhs;
    };
    home.packages = with pkgs; [
      dotnet-sdk_8
      jre
      nodejs
      openssl
    ];
  };
}
