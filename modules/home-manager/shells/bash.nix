{
  pkgs,
  lib,
  config,
  microfetch,
  ...
}:

{
  options.shell.bash.enable = lib.mkEnableOption "enable shell";

  config = lib.mkIf config.shell.bash.enable {
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
      microfetch.microfetch
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

    xdg = {
      enable = true;
      desktopEntries."btop" = {
        name = "btop++";
        noDisplay = true;
      };
    };
  };
}
