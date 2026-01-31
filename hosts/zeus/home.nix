{
  config,
  pkgs,
  gruvbox-plus-icons-git,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [
    ../../modules/home-manager
  ];

  config = {

    home.homeDirectory = "/home/zeus";
    home.username = "zeus";
    # This value determines the Home Manager release that your configuration is
    # compatible with.
    home.stateVersion = "25.05"; # Do not change unless you know what you are doing!
    
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
