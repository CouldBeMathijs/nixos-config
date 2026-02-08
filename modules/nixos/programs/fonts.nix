{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "fonts";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    # Set nerd-fonts and ms-fonts
    fonts.packages = with pkgs; [
      ubuntu-sans
      # Microsoft fonts
      vista-fonts
      corefonts
      # Nerd fonts
      nerd-fonts.jetbrains-mono
      # toki pona
      nasin-nanpa
      linja-sike
      sitelen-seli-kiwen
    ];
  };
}
