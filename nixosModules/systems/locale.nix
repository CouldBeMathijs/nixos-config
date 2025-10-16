{ lib, config, ...}:
let
        locales = {
                irish = { 
                        code = "en_IE.UTF-8"; 
                        timeZone = "Europe/Brussels";
                };
                finnish = { 
                        code = "fi_FI.UTF-8"; 
                        timeZone = "Europe/Brussels"; 
                };
        };

        selectedLanguage = locales.${config.locale.language} or locales.irish;
        finnishLocale = "fi_FI.UTF-8/UTF-8";
in
        {
        options = {
                locale.enable = lib.mkEnableOption "enable locale.nix";

                locale.language = lib.mkOption {
                        type = lib.types.str;
                        default = "irish"; 
                        description = ''
        The language locale to use. Supported values are "irish" (en_IE.UTF-8) or 
        "finnish" (fi_FI.UTF-8).
                        '';
                };
        };

        config = lib.mkIf config.locale.enable {

                time.timeZone = selectedLanguage.timeZone;
                i18n.defaultLocale = selectedLanguage.code;

                i18n.extraLocaleSettings = {
                        LC_ADDRESS = selectedLanguage.code;
                        LC_IDENTIFICATION = selectedLanguage.code;
                        LC_MEASUREMENT = selectedLanguage.code;
                        LC_MONETARY = selectedLanguage.code;
                        LC_NAME = selectedLanguage.code;
                        LC_NUMERIC = selectedLanguage.code;
                        LC_PAPER = selectedLanguage.code;
                        LC_TELEPHONE = selectedLanguage.code;
                        LC_TIME = selectedLanguage.code;
                };

                i18n.extraLocales = 
                        [ "en_GB.UTF-8/UTF-8" "nl_BE.UTF-8/UTF-8" ] 
                        ++ lib.optionals (config.locale.language == "finnish") [ finnishLocale ];
                services.xserver = {
                        xkb.layout = "us";
                        xkbVariant = "alt-intl";
                        #xkbOptions = "grp:win_space_toggle";
                };

                console.keyMap = "us";

        };
}
