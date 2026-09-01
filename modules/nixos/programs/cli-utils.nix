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
      fd # Better find
      file # File information
      ghostty.terminfo # Fix ssh when remoting using ghostty
      git # Version control for the modern age
      killall # Kill all instances of a program
      p7zip # Compression and stuff
      pbpctrl # Control Pixel Buds Pro from the cli
      ripgrep # Better grep
      tree # Tree folder view
      ugrep # Even better (but also a little slower, grep)
      unzip # Make it not zipped
      wget # Download things from the World Wide Web
      wl-clipboard # wl-clip all the way
      xdg-utils # Some needed utils like open
      zip # Make it not unzipped
    ];
  };
}
