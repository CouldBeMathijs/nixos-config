{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "bash";
  cfg = config.shell.${name};
in
{
  options.shell.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    programs.bat.enable = true;
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
    };
    programs.eza.enable = true;

    home.packages = with pkgs; [
      microfetch
      tealdeer
      trash-cli
      yazi
      bat-extras.batman
    ];

    programs.bash = {
      enable = true;
      initExtra = "microfetch";
      shellAliases = {
        ".." = "cd ..";
        "cat" = "bat";
        "clear" = "clear; microfetch";
        "ll" = "eza -l";
        "ls" = "eza";
        "man" = "batman";
        "open" = "xdg-open";
      };
    };
    programs.starship = {
      enableBashIntegration = true;
    };

    xdg = {
      enable = true;
      desktopEntries."btop" = {
        name = "btop++";
        noDisplay = true;
      };
    };
  };
}
