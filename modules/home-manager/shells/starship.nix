{ lib, config, ... }:

{
  options.starship.enable = lib.mkEnableOption "enable my starship config";

  config = lib.mkIf config.shell.fish.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        format = "$hostname$directory$character";
        right_format = "$cmd_duration$nix_shell$git_branch$git_status";

        hostname = {
          ssh_only = true;
          format = "[$hostname]($style) in ";
          style = "bold dim white";
        };

        directory = {
          style = "bold blue";
          truncation_length = 3;
          fish_style_pwd_dir_length = 1;
        };

        character = {
          success_symbol = "[λ](bold green) ";
          error_symbol = "[λ](bold red) ";
        };

        nix_shell = {
          symbol = "󱄅 ";
          format = "via [$symbol$state]($style) ";
          style = "bold blue";
        };

        git_branch = {
          symbol = " ";
          style = "bold purple";
        };

        cmd_duration = {
          min_time = 500;
          format = "took [$duration]($style) ";
        };
      };
    };
  };
}
