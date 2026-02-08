{
  config,
  pkgs,
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
    browser.enable = false;
    shell.fish.enable = true;

    # This value determines the Home Manager release that your configuration is
    # compatible with.
    home.stateVersion = "25.11"; # Do not change unless you know what you are doing!

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
