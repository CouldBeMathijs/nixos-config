{ pkgs, lib, config, niri, ... }:
{
        options = {
                niri.enable = lib.mkEnableOption "enable niri.nix";
        };

        config = lib.mkIf config.niri.enable {
                nixpkgs.overlays = [ niri.overlays.niri ];

                programs.niri = {
                        enable = true;
                        package = pkgs.niri-stable;
                };
        };
}
