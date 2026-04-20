{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/desktop.nix
  ];

  shell.zsh.enable = true;
  plasma-theming.enable = true;

  # School things
  latex.enable = true;
  jetbrains.pycharm.enable = true;

  # Extras
  dosbox.enable = true;
  fun-cli.enable = true;
  gramps.enable = true;

  home.packages = with pkgs; [
    audacity
    kdePackages.kwordquiz
    kooha
    obs-studio
    shotcut
    xournalpp
    devede
    krita
  ];
}
