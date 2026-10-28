{ config, lib, ... }:
{
  # Temporary fix for https://github.com/NixOS/nixpkgs/issues/575192
  nixpkgs.overlays = lib.mkIf (config.virtualisation.vmware.host.enable or false) [
    (final: prev: {
      linuxPackages_latest = prev.linuxPackages_latest.extend (
        lfinal: lprev: {
          vmware = lprev.vmware.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              find $out/lib/modules -name "*.ko" -print0 | while IFS= read -r -d "" ko; do
                touch "$ko.cer"
                touch "$(dirname "$ko")/$(basename "$ko" .ko).ko.cer"
              done
            '';
          });
        }
      );

      linuxKernel = prev.linuxKernel // {
        packages = prev.linuxKernel.packages // {
          linux_7_3 = prev.linuxKernel.packages.linux_7_3.extend (
            lfinal: lprev: {
              vmware = lprev.vmware.overrideAttrs (old: {
                postInstall = (old.postInstall or "") + ''
                  find $out/lib/modules -name "*.ko" -print0 | while IFS= read -r -d "" ko; do
                    touch "$ko.cer"
                    touch "$(dirname "$ko")/$(basename "$ko" .ko).ko.cer"
                  done
                '';
              });
            }
          );
        };
      };
    })
  ];
}
