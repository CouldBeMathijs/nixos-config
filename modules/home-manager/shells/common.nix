{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.shell.common;
in
{
  options.shell.common = {
    enable = lib.mkEnableOption "Enable shared shell configuration";

    # Define two separate sets of shortcuts
    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        "cat" = "bat";
        "clear" = "command clear; microfetch";
        "ll" = "eza -l";
        "ls" = "eza";
        "man" = "batman";
        "open" = "xdg-open";
      };
    };

    abbrs = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        ".." = "cd ..";
        "gp" = "git pull";
        "restic-log" = "journalctl -u restic-backups-home-backup";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    bat.enable = true;
    tldr.enable = true;
    programs.zoxide.enable = true;
    programs.eza.enable = true;

    home.packages = with pkgs; [
      bat-extras.batman
      microfetch
      trash-cli
      yazi
    ];

    xdg = {
      enable = true;
      desktopEntries."btop" = {
        name = "btop++";
        noDisplay = true;
      };
    };
  };
}
