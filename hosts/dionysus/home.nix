{ pkgs, gruvbox-plus-icons-git, ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/desktop.nix
  ];

  shell.zsh.enable = true;
  plasma-theming.enable = true;
  latex.enable = true;
  dosbox.enable = true;
  helix.enable = true;
  ollama.enable = true;
  calibre.enable = false;

  home.packages = with pkgs; [
    subtitlecomposer
    obs-studio
  ];
}
