{ config, lib, ... }:
{
  # 2026-10-21: Force disable vmware https://github.com/NixOS/nixpkgs/issues/575192
  virtualisation.vmware.host.enable = lib.mkForce false;
}
