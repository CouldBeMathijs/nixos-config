{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "zsh";
  cfg = config.shell.${name};
  common = config.shell.common;
in
{
  imports = [ ./common.nix ];

  options.shell.${name}.enable = lib.mkEnableOption "Enable my ${name} configuration";

  config = lib.mkIf cfg.enable {
    shell.common.enable = true;

    programs.zsh = {
      enable = true;

      dotDir = "${config.home.homeDirectory}/.config/zsh";

      shellAliases = common.aliases // common.abbrs;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;

      initContent = ''
        zstyle ':prezto:module:prompt' theme 'none'
        microfetch
      '';
    };

    programs.atuin.enableZshIntegration = true;
    programs.starship.enableZshIntegration = true;
    programs.zoxide.enableZshIntegration = true;
  };
}
