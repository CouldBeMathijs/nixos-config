{ lib, ...}: {
        imports = [
                ./cliApps/fastfetch.nix
                ./cliApps/git.nix
                ./cliApps/shell.nix
                ./programs/browser.nix
                ./programs/composing.nix
                ./programs/csa-utils.nix
                ./programs/jetbrains.nix
                ./programs/latex.nix
                ./programs/minecraft.nix
                ./theming/cinnamon-theming.nix
                ./theming/gnome-extensions.nix
                ./theming/gnome-theming.nix
        ];
        browser.enable = lib.mkDefault true;
        git.enable = lib.mkDefault true;
}
