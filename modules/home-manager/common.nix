{ lib, ... }:

{
  fastfetch.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  helix.enable = lib.mkDefault true;
  nh.enable = lib.mkDefault true;
  nix-direnv.enable = lib.mkDefault true;
  shell.bash.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Default state version
  home.stateVersion = lib.mkDefault "25.11";
}
