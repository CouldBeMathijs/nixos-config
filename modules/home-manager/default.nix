{
  lib,
  config,
  ...
}:
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
    ./cli-apps/tldr.nix
    ./programs/browser.nix
    ./programs/calibre.nix
    ./programs/composing.nix
    ./programs/discord.nix
    ./programs/dosbox.nix
    ./programs/gramps.nix
    ./programs/jetbrains.nix
    ./programs/latex.nix
    ./programs/minecraft.nix
    ./programs/zed.nix
    ./shells/bash.nix
    ./shells/fish.nix
    ./shells/starship.nix
    ./shells/zsh.nix
    ./programs/mail.nix
  ];

  options = {
    custom.flake-dir = lib.mkOption {
      type = lib.types.path;
      description = "The path where the flake is stored";
      default = "${config.home.homeDirectory}/.dotfiles";
    };
  };
}
