{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "obs-studio";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
