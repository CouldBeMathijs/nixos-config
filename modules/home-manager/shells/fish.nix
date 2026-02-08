{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "fish";
  cfg = config.shell.${name};
in
{
  options.shell.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    bat.enable = true;

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.eza.enable = true;

    home.packages = with pkgs; [
      bat-extras.batman
      microfetch
      procps
      tealdeer
      trash-cli
      yazi
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
      enableFishIntegration = true;
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
