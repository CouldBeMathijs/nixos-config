{ lib, ... }:

{
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Default state version
  home.stateVersion = lib.mkDefault "25.11";
}
