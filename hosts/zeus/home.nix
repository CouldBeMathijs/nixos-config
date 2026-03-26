{ ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
  ];

  browser.enable = false;
  shell.zsh.enable = true;
}
