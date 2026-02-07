{ lib, pkgs, ... }:
{
  imports = [
    ./DE-WM/cinnamon-theming.nix
    ./DE-WM/gnome-extensions.nix
    ./DE-WM/gnome-theming.nix
    ./DE-WM/niri.nix
    ./DE-WM/plasma-theming.nix
    ./cli-apps/bat.nix
    ./cli-apps/direnv.nix
    ./cli-apps/fastfetch.nix
    ./cli-apps/fun-cli.nix
    ./cli-apps/git.nix
    ./cli-apps/helix.nix
    ./cli-apps/nh.nix
    ./cli-apps/ollama.nix
    ./programs/browser.nix
    ./programs/calibre.nix
    ./programs/composing.nix
    ./programs/csa-utils.nix
    ./programs/discord.nix
    ./programs/dosbox.nix
    ./programs/gramps.nix
    ./programs/jetbrains.nix
    ./programs/latex.nix
    ./programs/minecraft.nix
    ./shells/bash.nix
    ./shells/fish.nix
    ./shells/starship.nix
  ];
  browser.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  helix.enable = lib.mkDefault true;
  nh.enable = lib.mkDefault true;
  nix-direnv.enable = lib.mkDefault true;
  shell.bash.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
}
