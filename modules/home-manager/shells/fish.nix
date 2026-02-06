{
  pkgs,
  lib,
  config,
  microfetch,
  ...
}:

{
  options.shell.fish.enable = lib.mkEnableOption "enable shell";

  config = lib.mkIf config.shell.fish.enable {
    programs.bat.enable = true;

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.eza.enable = true;

    home.packages = with pkgs; [
      bat-extras.batman
      procps
      tealdeer
      trash-cli
      yazi
      microfetch.microfetch
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        microfetch
        set -g fish_greeting "" # Optional: Disables the default fish welcome message
      '';

      shellAliases = {
        ".." = "cd ..";
        "cat" = "bat";
        "clear" = "command clear; microfetch";
        "ll" = "eza -l";
        "ls" = "eza";
        "man" = "batman";
        "open" = "xdg-open";
      };
    };

    # Make fish launch immidiatly while keeping bash as the default shell
    programs.bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        nix_shell = {
          symbol = "❄️ ";
          format = "via [$symbol$state]($style) ";
        };
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
