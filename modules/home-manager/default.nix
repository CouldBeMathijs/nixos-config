{ lib, ...}: {
        imports = [
                ./cli-apps/bat.nix
                ./cli-apps/direnv.nix
                ./cli-apps/fastfetch.nix
                ./cli-apps/fun-cli.nix
                ./cli-apps/git.nix
                ./cli-apps/ollama.nix
                ./programs/browser.nix
                ./programs/composing.nix
                ./programs/csa-utils.nix
                ./programs/discord.nix
                ./programs/dosbox.nix
                ./programs/gramps.nix
                ./programs/jetbrains.nix
                ./programs/latex.nix
                ./programs/minecraft.nix
                ./programs/niri.nix
                ./shells/bash.nix
                ./theming/cinnamon-theming.nix
                ./theming/gnome-extensions.nix
                ./theming/gnome-theming.nix
                ./theming/plasma-theming.nix
        ];
        browser.enable = lib.mkDefault true;
        nix-direnv.enable = lib.mkDefault true;
        git.enable = lib.mkDefault true;
}
