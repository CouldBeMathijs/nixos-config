{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    cli-utils.enable = lib.mkEnableOption "enable cli-utils.nix";
  };
  config = lib.mkIf config.cli-utils.enable {
    environment.systemPackages = with pkgs; [
      btop # System monitor
      file # File information
      ghostty # You never want to end up without terminal emulator
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
