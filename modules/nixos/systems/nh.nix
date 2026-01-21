{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    nh.enable = lib.mkEnableOption "enable nh configuration for clean-up";
  };
  config = lib.mkIf config.nh.enable {
    environment.systemPackages = [ pkgs.nh ];
    programs.nh = {
      enable = true;
      clean.enable = true;
      # Clean up old generations by keeping the last day and at least 3 generations.
      clean.extraArgs = "--keep-since 1d --keep 3";
      flake = "/home/mathijs/.dotfiles";
    };
  };
}
