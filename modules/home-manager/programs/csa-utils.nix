{
  pkgs,
  lib,
  config,
  ...
}:
let
  mars-mips-icon-file = pkgs.runCommand "mars-mips-icon-file" { } ''
    mkdir -p $out/
    cp ${./images/mars-mips.png} $out/mars-mips.png
  '';

  marsIconConfig = lib.mkIf config.csa-utils.mars-icon.enable {
    xdg.enable = true;
    xdg.desktopEntries."mars" = {
      name = "Mars MIPS";
      categories = [
        "Development"
        "IDE"
      ];
      comment = "IDE for programming in MIPS assembly language intended for educational-level use";
      genericName = "MIPS Editor";
      exec = "Mars";
      type = "Application";
      icon = "${mars-mips-icon-file}/mars-mips.png";
    };
  };

in
{
  options = {
    csa-utils.enable = lib.mkEnableOption "Enable csa-utils configuration";
    csa-utils.mars-icon.enable = lib.mkEnableOption "Enable the custom mars icon";
  };

  config = lib.mkIf config.csa-utils.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          logisim # Live laugh Logisim - Swiepie (2024)
          mars-mips # MIPS Assembly IDE
        ];
      }
      marsIconConfig
    ]
  );
}
