{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.locale;
  fullLocale = "${cfg.code}.UTF-8";
in
{
  options = {
    locale.enable = lib.mkEnableOption "enable locale";

    locale.code = lib.mkOption {
      type = lib.types.str;
      default = "en_IE";
      example = "fi_FI";
      description = ''
        The locale identifier (language_COUNTRY). 
        The module will automatically append .UTF-8 where applicable.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = lib.mkDefault "Europe/Brussels";

    i18n.defaultLocale = fullLocale;

    i18n.extraLocaleSettings = {
      LC_ALL = fullLocale;
    };

    i18n.supportedLocales = [
      "${fullLocale}/UTF-8"
      "en_IE.UTF-8/UTF-8"
      "nl_BE.UTF-8/UTF-8"
      "fi_FI.UTF-8/UTF-8"
    ];

    services.xserver = {
      xkb.extraLayouts = {
        qwerty-fr = {
          description = "Qwerty FR";
          languages = [ "fra" ];
          symbolsFile = "${pkgs.qwerty-fr}/share/X11/xkb/symbols/us_qwerty-fr";
        };
      };
      xkb.layout = "qwerty-fr";
    };

    console.keyMap = "us";
  };
}
