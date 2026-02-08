{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "bat";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
        # other styles available and cane be combined
        #  style = "numbers,changes,headers,rule,grid";
        style = "full";
        # Bat has other thems as well
      };
      extraPackages = with pkgs.bat-extras; [
        batman
        batpipe
        # batgrep - disabled due to test failures
      ];
    };
    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
