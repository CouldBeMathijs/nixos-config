{
  config,
  pkgs,
  lib,
  ...
}:

let
  coreutils = pkgs.coreutils;
  gnused = pkgs.gnused;

  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "patched-desktop-entry-for-${appName}" { } ''
        ${coreutils}/bin/mkdir -p $out/share/applications

        ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );

  GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
  isNvidiaOffloadEnabled = config.hardware.nvidia.prime.offload.enable or false;

  steamOffloadPatch = lib.mkIf (config.gaming.steam.enable && isNvidiaOffloadEnabled) (
    GPUOffloadApp pkgs.steam "steam"
  );

  heroicOffloadPatch = lib.mkIf (config.gaming.heroic.enable && isNvidiaOffloadEnabled) (
    GPUOffloadApp pkgs.heroic "com.heroicgameslauncher.hgl"
  );

in
{
  options.gaming = {
    steam.enable = lib.mkEnableOption "Enable installation of Steam and automatic NVIDIA Prime GPU offloading for its desktop entry.";
    heroic.enable = lib.mkEnableOption "Enable installation of Heroic Games Launcher and automatic NVIDIA Prime GPU offloading for its desktop entry.";
  };

  config = {
    # Hardware acceleration settings
    hardware = lib.mkIf (config.gaming.steam.enable || config.gaming.heroic.enable) {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    programs.steam = lib.mkIf config.gaming.steam.enable {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    environment.systemPackages = lib.mkMerge [
      (lib.optionals config.gaming.heroic.enable [ pkgs.heroic ])
      # Add patched offload desktop entries
      (lib.optionals config.gaming.steam.enable [ steamOffloadPatch ])
      (lib.optionals config.gaming.heroic.enable [ heroicOffloadPatch ])
    ];
  };
}
