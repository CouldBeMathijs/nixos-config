{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    fonts.enable = lib.mkEnableOption "enable fonts.nix";
  };
  config = lib.mkIf config.fonts.enable {
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
