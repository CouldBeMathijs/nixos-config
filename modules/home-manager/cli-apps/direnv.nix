{
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  name = "nix-direnv";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    programs.direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    home.packages = with pkgs; [
      direnv
      nix-direnv
    ];
  };
}
