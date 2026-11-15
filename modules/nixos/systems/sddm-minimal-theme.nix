{
  pkgs,
  lib,
  config,
  ...
}:

let
  sddm-minimal-theme-pkg = pkgs.where-is-my-sddm-theme.override {
    themeConfig.General = {
      # --- General Appearance ---
      backgroundFill = "#101010";
      basicTextColor = "#ebdbb2"; # Gruvbox Light Foreground
      font = "Hurmit Nerd Font Propo";

      # --- Password Input ---
      passwordInputBackground = "#1d2021";
      passwordTextColor = "#ebdbb2";
      passwordInputRadius = "32";
      passwordInputWidth = "0.3";
      passwordCursorColor = "#fe8019";
      passwordFontSize = "36";

      # --- Selection Settings ---
      showSessionsByDefault = "true";
      sessionsFontSize = "14";
      showUsersByDefault = "true";
      usersFontSize = "18";
      showUserRealNameByDefault = "true";

      # --- Miscellaneous ---
      cursorBlinkAnimation = "true";
      passwordcharacter = "•"; # Modern bullet instead of *
    };
  };
in
{
  options = {
    sddm-minimal-theme.enable = lib.mkEnableOption "enable sddm-minimal-theme.nix";
  };

  config = lib.mkIf config.sddm-minimal-theme.enable {
    services.displayManager.sddm.wayland.enable = true;
    environment.systemPackages = [
      sddm-minimal-theme-pkg
    ];
    services.displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme";
      # Ensure the theme package is available to SDDM
      extraPackages = [ sddm-minimal-theme-pkg ];
    };
  };
}
