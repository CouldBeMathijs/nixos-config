{
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  name = "calibre";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.calibre = {
      enable = true;
    };
  };
}
/*
  /
  If you want to enable ACSM support:

  git clone https://github.com/nydragon/calibre-plugins;
  cd calibre-plugins;
  nix build .#dedrm-plugin --override-input nixpkgs github:NixOS/nixpkgs/nixos-unstable;
  calibre-customize -a result;
  rm result;
  nix build .#acsm-calibre-plugin --override-input nixpkgs github:NixOS/nixpkgs/nixos-unstable;
  calibre-customize -a result;
  rm result;

  Then restart calibre and follow the guide on the acsm-plugin starting after installation

  /
*/
