{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/desktop.nix
  ];

  shell.zsh.enable = true;
  niri-config.enable = true;

  # Extras
  dosbox.enable = true;
  fun-cli.enable = true;
  gramps.enable = true;
  vivaldi.enable = true;
  osc-suse-cli.enable = true;

  home.packages = with pkgs; [
    audacity
    drawy
    kdePackages.kwordquiz
    kooha
    shotcut
    xournalpp
  ];
}
