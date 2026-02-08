{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "git";
  cfg = config.${name};
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };
  config = lib.mkIf cfg.enable {

    # Git configuration
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Mathijs";
          email = "79464596+CouldBeMathijs@users.noreply.github.com";
        };
        init.defaultBranch = "main";
      };
    };
    home.packages = with pkgs; [
      gh # Github client
      git # Duh
      git-filter-repo
    ];
  };
}
