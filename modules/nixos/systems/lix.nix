{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    lix.enable = lib.mkEnableOption "enable lix config";
  };
  config = lib.mkIf config.lix.enable {
    # Enable lix
    nixpkgs.overlays = [
      (final: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];
    nix.package = pkgs.lixPackageSets.stable.lix;
  };
}
