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
      backgroundFill = "#1d2021"; # Gruvbox Dark Hard Background
      basicTextColor = "#ebdbb2"; # Gruvbox Light Foreground
      font = "JetBrainsMono Nerd Font"; # Use a nice mono font if available

      # --- Password Input ---
      passwordInputBackground = "#3c3836"; # Gruvbox Dark Gray
      passwordTextColor = "#ebdbb2";
      passwordInputRadius = "5"; # Subtle rounded corners
      passwordInputWidth = "0.3"; # Minimalist narrow input
      passwordCursorColor = "#fe8019"; # Gruvbox Orange for focus
      passwordFontSize = "36"; # Smaller, more elegant size

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
