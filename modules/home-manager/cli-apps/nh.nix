{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.nh.enable = lib.mkEnableOption "enable nh configuration for clean-up";

  config = lib.mkIf config.nh.enable {
    home.packages = [ pkgs.nh ];

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
