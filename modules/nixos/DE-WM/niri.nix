{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "niri";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
  };
}
