{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.schoolutils;

  # Helper for the MARS icon and desktop entry
  mars-desktop-item = pkgs.makeDesktopItem {
    name = "mars";
    desktopName = "Mars MIPS";
    genericName = "MIPS Editor";
    comment = "IDE for programming in MIPS assembly language intended for educational-level use";
    categories = [
      "Development"
      "IDE"
    ];
    exec = "Mars";
    icon = ./images/mars-mips.png; # Nix can reference local paths directly here
    type = "Application";
  };

  # Logic for CSA (Computer Systems Architecture)
  csaConfig = lib.mkIf cfg.csa.enable {
    environment.systemPackages =
      with pkgs;
      [
        logisim
        mars-mips
      ]
      ++ lib.optional cfg.csa.mars-icon-enable mars-desktop-item;
  };

  # Logic for CN (Computer Networks)
  cnConfig = lib.mkIf cfg.cn.enable {
    environment.systemPackages = with pkgs; [
      mininet
      wireshark
    ];
    # Wireshark usually needs the setuid wrapper/group to capture packets
    programs.wireshark.enable = true;
  };

  # Logic for Compilers
  compilerConfig = lib.mkIf cfg.compilers.enable {
    environment.systemPackages = with pkgs; [
      xspim
      qtspim
    ];
  };
in
{
  options.schoolutils = {
    csa = {
      enable = lib.mkEnableOption "Enable CSA (Computer Systems Architecture) tools";
      mars-icon-enable = lib.mkEnableOption "Enable the custom mars icon";
    };
    cn = {
      enable = lib.mkEnableOption "Enable CN (Computer Networks) tools";
    };
    compilers = {
      enable = lib.mkEnableOption "Enable Compilers tools";
    };
  };

  config = lib.mkMerge [
    csaConfig
    cnConfig
    compilerConfig
  ];
}
