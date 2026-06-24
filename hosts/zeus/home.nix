{ ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
  ];

  shell.zsh.enable = true;
}
