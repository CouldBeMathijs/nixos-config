{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "auto-updater";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable automated git pull and nixos-rebuild";
    flakeDir = lib.mkOption {
      type = lib.types.str;
      description = "The absolute path to the flake directory.";
      example = "/home/user/.dotfiles/";
    };
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      flags = [
        "--flake"
        "${cfg.flakeDir}"
      ];
    };

    systemd.services.nixos-upgrade.preStart = ''
      cd ${cfg.flakeDir}
      ${pkgs.git}/bin/git pull
    '';

    nix = {
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
