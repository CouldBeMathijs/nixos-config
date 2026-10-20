{ config, ... }:
{
  # Fix: vloopback build failure for kernel: 2026-10-26
  boot.extraModulePackages = [
    (config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        rm -f $out/lib/modules/*/{modules.builtin.bin,modules.builtin,modules.order}
      '';
    }))
  ];
}
