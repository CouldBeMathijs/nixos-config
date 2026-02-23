{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "bash";
  cfg = config.shell.${name};
  common = config.shell.common;
in
{
  imports = [ ./common.nix ];

  options.shell.${name}.enable = lib.mkEnableOption "Enable my ${name} configuration";

  config = lib.mkIf cfg.enable {
    shell.common.enable = true;

    programs.bash = {
      enable = true;
      # Merge both sets into aliases since Bash only supports one type
      shellAliases = common.aliases // common.abbrs;
      initExtra = "microfetch";
    };

    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.starship.enableBashIntegration = true;
    programs.zoxide.enableBashIntegration = true;
  };
}
