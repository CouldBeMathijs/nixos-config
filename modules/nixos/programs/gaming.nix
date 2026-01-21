{
  config,
  pkgs,
  lib,
  ...
}:

# These helper functions are used to create a new derivation that holds a patched
# desktop entry, giving it higher priority than the original.
with pkgs;
let
  # The essential packages for the script to run (coreutils for mkdir, gnused for sed)
  coreutils = pkgs.coreutils;
  gnused = pkgs.gnused;

  # Helper to patch a desktop file in a package using a simple substitution
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "patched-desktop-entry-for-${appName}" { } ''
        # Create directory structure in the output
        ${coreutils}/bin/mkdir -p $out/share/applications

        # Use sed to perform the substitution and write the patched file to $out
        ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );

  # Specific patch to prepend 'Exec=' with 'Exec=nvidia-offload '
  GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";

  # Configuration check: Determines if NVIDIA Prime Offload is active system-wide
  isNvidiaOffloadEnabled = config.hardware.nvidia.prime.offload.enable or false;

  # Conditionally applies the offload patch for Steam
  steamOffloadPatch = lib.mkIf (config.gaming.steam.enable && isNvidiaOffloadEnabled) (
    GPUOffloadApp pkgs.steam "steam"
  );

  # Conditionally applies the offload patch for Heroic
  heroicOffloadPatch = lib.mkIf (config.gaming.heroic.enable && isNvidiaOffloadEnabled) (
    GPUOffloadApp pkgs.heroic "com.heroicgameslauncher.hgl"
  );

in
{
  # Define the user-facing options for this module
  options.gaming = {
    steam.enable = lib.mkEnableOption "Enable installation of Steam and automatic NVIDIA Prime GPU offloading for its desktop entry.";
    heroic.enable = lib.mkEnableOption "Enable installation of Heroic Games Launcher and automatic NVIDIA Prime GPU offloading for its desktop entry.";
  };

  # Configure the system based on the defined options
  config = {
    hardware = lib.mkIf (config.gaming.steam.enable || config.gaming.heroic.enable) {
      # Enable OpenGL support and 32-bit libraries for gaming compatibility.
      graphics = {
        enable = true;
        enable32Bit = true; # Essential for 32-bit Steam and most games.
      };

      # Enable the AMDVLK Vulkan driver and its 32-bit support.
      /**
        amdgpu.amdvlk = {
          enable = true;
          support32Bit.enable = true;
        };
          *
      */

    };

    environment.systemPackages = lib.mkMerge [
      # 1. Add the base packages if their respective options are enabled
      (lib.optionals config.gaming.steam.enable [ pkgs.steam ])
      (lib.optionals config.gaming.heroic.enable [ pkgs.heroic ])

      # 2. Add the patched offload desktop entries.
      #    These are only included if the app is enabled AND the global
      #    NVIDIA offload setting is true.
      (lib.optionals config.gaming.steam.enable [ steamOffloadPatch ])
      (lib.optionals config.gaming.heroic.enable [ heroicOffloadPatch ])
    ];
  };
}
