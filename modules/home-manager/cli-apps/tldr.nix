{
  lib,
  config,
  ...
}:
let
  name = "tldr";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };
  };
}
