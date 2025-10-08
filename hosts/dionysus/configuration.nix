# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, pkgs-unstable, config, lib, ... }:

{
        networking.hostName = "dionysus";

        ripping.enable = true;
        cinnamon.enable = true;

        gaming.steam.enable = true;
        gaming.heroic.enable = true;

        # Allow unfree packages
        nixpkgs.config.allowUnfree = true;

        # Enable networking
        networking.networkmanager.enable = true;

        imports = [
                ./../../nixosModules
        ];
        services = {
                envfs.enable = true;
                fwupd.enable = true;
        };
        security.rtkit.enable = true;

        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.users.mathijs = {
                isNormalUser = true;
                description = "Mathijs Pittoors";
                extraGroups = [ "networkmanager" "wheel" ];
        };

        # List packages installed in system profile. To search, run:
        # $ nix search wget
        environment.systemPackages = with pkgs; [
                # Media
                gimp # GNU Image Manipulation Program

                # Documents
                # gramps # Geneology
                libreoffice # Office Suite

                # Back-ups
                deja-dup 
        ];

        boot = {
                kernelPackages = pkgs.linuxPackages_zen;
                loader = {
                        systemd-boot.enable = true;
                        efi.canTouchEfiVariables = true;
                };
        };

        # Nvidia

        # Enable OpenGL
        hardware.graphics = {
                enable = true;
        };

        # Load nvidia driver for Xorg and Wayland
        services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

        hardware.nvidia = {

                # Modesetting is required.
                modesetting.enable = true;

                # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
                # Enable this if you have graphical corruption issues or application crashes after waking
                # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
                # of just the bare essentials.
                powerManagement.enable = false;

                # Fine-grained power management. Turns off GPU when not in use.
                # Experimental and only works on modern Nvidia GPUs (Turing or newer).
                powerManagement.finegrained = false;

                # Use the NVidia open source kernel module (not to be confused with the
                # independent third-party "nouveau" open source driver).
                # Support is limited to the Turing and later architectures. Full list of 
                # supported GPUs is at: 
                # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
                # Only available from driver 515.43.04+
                open = false;

                # Enable the Nvidia settings menu,
                # accessible via `nvidia-settings`.
                nvidiaSettings = true;

                # Optionally, you may need to select the appropriate driver version for your specific GPU.
                package = config.boot.kernelPackages.nvidiaPackages.stable;

                prime = {
                        offload = {
                                enable = true;
                                enableOffloadCmd = true;
                        };
                        nvidiaBusId = "PCI:1:0:0"; 
                        amdgpuBusId = "PCI:5:0:0"; 
                };
        };



        # Do not change me unless you know what you are doing!! Check documentation first!!
        system.stateVersion = "25.05"; # Did you read the comment?

        # Enable Flakes
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
