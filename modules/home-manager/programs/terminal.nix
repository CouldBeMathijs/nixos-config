{
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  name = "terminal";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      settings = {
        theme = "Selenized Black";
        font-family = "Hurmit Nerd Font Mono";
      };
    };
    xdg = {
      enable = true;
      desktopEntries = {
        "com.mitchellh.ghostty" = {
          name = "Ghostty";
          genericName = "Terminal Emulator";
          comment = "A terminal emulator";
          exec = "ghostty";
          icon = "terminal";
          categories = [
            "System"
            "TerminalEmulator"
          ];
          startupNotify = true;
          terminal = false;
          actions = {
            new-window = {
              name = "New Window";
              exec = "ghostty";
            };
          };
        };
      };
    };
  };
}
