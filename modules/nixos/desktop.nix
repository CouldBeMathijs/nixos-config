{ lib, ... }:

{
  audio.enable = lib.mkDefault true;
  fonts.enable = lib.mkDefault true;
  plymouth.enable = lib.mkDefault true;
  printing.enable = lib.mkDefault true;
}
