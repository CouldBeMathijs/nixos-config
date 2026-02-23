{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "fish";
  cfg = config.shell.${name};
  common = config.shell.common;
in
{
  imports = [ ./common.nix ];

  options.shell.${name}.enable = lib.mkEnableOption "Enable my ${name} configuration";

  config = lib.mkIf cfg.enable {
    shell.common.enable = true;

    programs.fish = {
      enable = true;
      shellAliases = common.aliases;
      shellAbbrs = common.abbrs // {
        "!!" = {
          position = "anywhere";
          function = "last_history_item";
        };
      };

      functions.last_history_item = "echo $history[1]";

      interactiveShellInit = ''
        microfetch
        set -g fish_greeting "" 
      '';
    };

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

    programs.starship.enableFishIntegration = true;
    programs.zoxide.enableFishIntegration = true;
  };
}
