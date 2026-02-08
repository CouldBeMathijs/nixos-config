{
  pkgs,
  lib,
  config,
  niri,
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
    nixpkgs.overlays = [ niri.overlays.niri ];

    programs.niri = {
      enable = true;
      package = pkgs.niri-stable;
    };
  };
}
