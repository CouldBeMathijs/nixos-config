{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/desktop.nix
  ];

  shell.zsh.enable = true;
  niri-config.enable = true;
  dosbox.enable = true;
  helix.enable = true;
  ollama.enable = true;
  vivaldi.enable = true;
  calibre.enable = true;

  home.packages = with pkgs; [
    subtitlecomposer
  ];
}
