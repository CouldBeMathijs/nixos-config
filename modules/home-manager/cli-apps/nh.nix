{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "nh";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 1d --keep 3";
      };
      flake = "${config.home.homeDirectory}/.dotfiles";
    };
  };
}
