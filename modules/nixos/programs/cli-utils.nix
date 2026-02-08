{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "cli-utils";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btop # System monitor
      file # File information
      git # Version control for the modern age
      killall # Kill all instances of a program
      pbpctrl # Control Pixel Buds Pro from the cli
      tree # Tree folder view
      unzip # Make it not zipped
      wget # Download things from the World Wide Web
      wl-clipboard # wl-clip all the way
      xdg-utils # Some needed utils like open
      zip # Make it not unzipped
    ];
  };
}
