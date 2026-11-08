{ config, lib, ... }:
{
  # 2026-10-21: Force disable vmware https://github.com/NixOS/nixpkgs/issues/575192
  # virtualisation.vmware.host.enable = lib.mkForce false;
  nixpkgs.overlays = [
    (final: prev: {
      # 1. Custom userspace workstation package
      vmware-workstation = final.callPackage ../../packages/vmware-workstation-custom.nix { };

      # 2. Kernel module package fix for aggregateModules (.ko.cer generation)
      linuxPackages_latest = prev.linuxPackages_latest.extend (
        lfinal: lprev: {
          vmware = lprev.vmware.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              if [ -d "$out/lib/modules" ]; then
                find "$out/lib/modules" -name "*.ko" -print0 | while IFS= read -r -d "" ko; do
                  touch "$ko.cer"
                  touch "$(dirname "$ko")/$(basename "$ko" .ko).ko.cer"
                done
              fi
            '';
          });
        }
      );
    })
  ];

  optical.ripping.enable = lib.mkForce false;
}
