{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.jetbrains = {
    enable = lib.mkEnableOption "Enable Pycharm and Clion";

    pycharm = {
      enable = lib.mkEnableOption "Enable PyCharm";
    };

    clion = {
      enable = lib.mkEnableOption "Enable CLion";
    };
  };

  config = {
    # If the top-level jetbrains.enable is set, enable the individual options
    jetbrains.pycharm.enable = lib.mkIf config.jetbrains.enable true;
    jetbrains.clion.enable = lib.mkIf config.jetbrains.enable true;

    home.packages =
      lib.optional config.jetbrains.pycharm.enable pkgs.jetbrains.pycharm
      ++ lib.optional config.jetbrains.clion.enable pkgs.jetbrains.clion;
  };
}
