{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/desktop.nix
  ];

  shell.zsh.enable = true;
  plasma-config.enable = true;
  dosbox.enable = true;
  helix.enable = true;
  calibre.enable = false;
  niri-config.enable = true;

  home.packages = with pkgs; [
    subtitlecomposer
  ];
}
