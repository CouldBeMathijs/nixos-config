{
  pkgs,
  lib,
  config,
  options,
  ...
}:
{
  options = {
    gramps.enable = lib.mkEnableOption "Enable gramps configuration";
  };

  config = lib.mkIf config.gramps.enable {
    home.packages = with pkgs; [
      gramps
    ];
  };
}
