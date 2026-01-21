{
  pkgs,
  lib,
  config,
  options,
  ...
}:
{
  options = {
    minecraft.enable = lib.mkEnableOption "Enable minecraft configuration";
  };

  config = lib.mkIf config.minecraft.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
