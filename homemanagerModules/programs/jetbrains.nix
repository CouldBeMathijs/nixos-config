{ pkgs-unstable, lib, config, ... }:

{
  options.jetbrains = {
    enable = lib.mkEnableOption "Enable all JetBrains IDEs (PyCharm and CLion)";

    pycharm = {
      enable = lib.mkEnableOption "Enable PyCharm Professional";
    };

    clion = {
      enable = lib.mkEnableOption "Enable CLion";
    };
  };

  config = {
    # If the top-level jetbrains.enable is set, enable the individual options
    jetbrains.pycharm.enable = lib.mkIf config.jetbrains.enable true;
    jetbrains.clion.enable = lib.mkIf config.jetbrains.enable true;

    home.packages = lib.optional config.jetbrains.pycharm.enable pkgs-unstable.jetbrains.pycharm-professional
                 ++ lib.optional config.jetbrains.clion.enable pkgs-unstable.jetbrains.clion;
  };
}

