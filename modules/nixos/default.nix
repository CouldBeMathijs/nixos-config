{ lib, ...}: {
        imports = [
                ./DE-WM/cinnamon.nix
                ./DE-WM/gnome.nix
                ./DE-WM/niri.nix
                ./DE-WM/plasma.nix
                ./programs/cli-utils.nix
                ./programs/fonts.nix
                ./programs/gaming.nix
                ./programs/gnome-apps.nix
                ./programs/plasma-apps.nix
                ./programs/ripping.nix
                ./systems/audio.nix
                ./systems/lix.nix
                ./systems/locale.nix
                ./systems/nh.nix
                ./systems/plymouth.nix
                ./systems/printing.nix
                ./systems/sddm-minimal-theme.nix
        ];
        audio.enable = lib.mkDefault true;
        cli-utils.enable = lib.mkDefault true;
        fonts.enable = lib.mkDefault true;
        lix.enable = lib.mkDefault true;
        locale.enable = lib.mkDefault true;
        nh.enable = lib.mkDefault true;
        plymouth.enable = lib.mkDefault true;
        printing.enable = lib.mkDefault true;
}
