{ config, lib, ... }:
{
  # 2026-10-21: Force disable vmware https://github.com/NixOS/nixpkgs/issues/575192
  nixpkgs.overlays = [
    (final: prev: {
      vmware-workstation = final.callPackage ../../packages/vmware-workstation-custom.nix { };

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
}
