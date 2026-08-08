{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/desktop.nix
  ];

  shell.zsh.enable = true;
  helix.enable = true;
  niri-config.enable = true;

  home.packages = with pkgs; [
    subtitlecomposer
  ];
}
