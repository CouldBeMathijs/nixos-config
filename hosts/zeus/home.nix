{ ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/common.nix
  ];
  osc-suse-cli.enable = true;
}
