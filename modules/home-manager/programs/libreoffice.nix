{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "libreoffice";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      hunspell
      hunspellDicts.en_GB-ize
      hunspellDicts.en_US
      hunspellDicts.fr-moderne
      hunspellDicts.nl_NL
      libreoffice
    ];
  };
}
