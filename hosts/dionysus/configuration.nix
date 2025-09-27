# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, pkgs-unstable, ... }:

{
        networking.hostName = "dionysus";
        
        ripping.enable = true;
        cinnamon.enable = true;

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
                # Command Line tools (CLI)
                gh # Github CLI-client

                # Communication
                signal-desktop # Signal messenger
                vesktop # Discord client

                # Development
                logisim # Live laugh Logisim - Swiepie (2024)
                mars-mips # MIPS Assembly IDE

                # Media
                gimp # GNU Image Manipulation Program
                musescore # Writing music scores
                muse-sounds-manager # Write music scores with better playback

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

        # Do not change me unless you know what you are doing!! Check documentation first!!
        system.stateVersion = "25.05"; # Did you read the comment?

        # Enable Flakes
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
