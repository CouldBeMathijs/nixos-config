{
  lib,
  config,
  pkgs,
  ...
}:
let
  imageMimeTypes = [
    "image/jpeg"
    "image/png"
    "image/jxl"
    "image/webp"
  ];

  audioMimeTypes = [
    "audio/mpeg"
    "audio/wav"
    "audio/x-aac"
    "audio/x-aiff"
    "audio/x-ape"
    "audio/x-flac"
    "audio/x-m4a"
    "audio/x-m4b"
    "audio/x-mp1"
    "audio/x-mp2"
    "audio/x-mp3"
    "audio/x-mpeg"
    "audio/x-mpegurl"
    "audio/x-mpg"
    "audio/x-opus+ogg"
    "audio/x-pn-aiff"
    "audio/x-pn-au"
    "audio/x-pn-wav"
    "audio/x-speex"
    "audio/x-vorbis"
    "audio/x-vorbis+ogg"
    "audio/x-wavpack"
  ];

  videoMimeTypes = [
    "video/3gp"
    "video/3gpp"
    "video/3gpp2"
    "video/divx"
    "video/dv"
    "video/fli"
    "video/flv"
    "video/mp2t"
    "video/mp4"
    "video/mp4v-es"
    "video/mpeg"
    "video/mpeg-system"
    "video/msvideo"
    "video/ogg"
    "video/quicktime"
    "video/vnd.mpegurl"
    "video/vnd.rn-realvideo"
    "video/webm"
    "video/x-avi"
    "video/x-flc"
    "video/x-fli"
    "video/x-flv"
    "video/x-m4v"
    "video/x-matroska"
    "video/x-mpeg"
    "video/x-mpeg-system"
    "video/x-mpeg2"
    "video/x-ms-asf"
    "video/x-ms-wm"
    "video/x-ms-wmv"
    "video/x-ms-wmx"
    "video/x-msvideo"
    "video/x-nsv"
    "video/x-ogm+ogg"
    "video/x-theora"
    "video/x-theora+ogg"
  ];

  mkMimeAssoc = mimeTypes: desktopFile: lib.genAttrs mimeTypes (_: desktopFile);
in
{
  options.niri-config = {
    enable = lib.mkEnableOption "Enable niri-config configuration";
  };

  config = lib.mkIf config.niri-config.enable {
    services.gnome-keyring.enable = true;
    home.packages = with pkgs; [
      file-roller
      gcr_4
      hyprpicker
      loupe
      mpd
      mpv
    ];
    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = lib.mkMerge [
          {
            "application/zip" = "org.gnome.FileRoller.desktop";
            "inode/directory" = "org.gnome.Nautilus.desktop";
          }
          (mkMimeAssoc imageMimeTypes "org.gnome.Loupe.desktop")
          (mkMimeAssoc audioMimeTypes "mpd.desktop")
          (mkMimeAssoc videoMimeTypes "mpv.desktop")
        ];
      };
      portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        config.common.default = "*";
      };
    };

    home.pointerCursor = {
      enable = true;
      package = (
        pkgs.bibata-cursors.overrideAttrs (oldAttrs: {
          buildPhase = ''
            runHook preBuild

            ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Ice -n 'Bibata-Modern-Ice' -c 'White and rounded edge Bibata XCursors'

            runHook postBuild
          '';
        })
      );
      name = "Bibata-Modern-Ice";
      size = 16;
    };

    dconf = {
      enable = true;
      settings = {
        # Change button layout
        "org/gnome/desktop/wm/preferences" = {
          button-layout = ":appmenu";
        };

        # Privacy settings
        "org/gnome/desktop/privacy" = {
          recent-files-max-age = 30;
          old-files-age = 30;
          remove-old-temp-files = true;
          remove-old-trash-files = true;
        };

        # Font settings
        "org/gnome/desktop/interface" = {
          document-font-name = "JetBrainsMono Nerd Font 11";
          font-name = "JetBrainsMono Nerd Font 11";
          monospace-font-name = "JetBrainsMono Nerd Font 11";
        };
      };
    };

    programs.noctalia = {
      enable = true;
      settings = lib.mkDefault ../../../non-nixlang/noctalia.toml;
    };
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.theme = null;
    };

    xdg.configFile = {
      "gtk-4.0/assets".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css" = {
        source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
        force = true;
      };
      "gtk-4.0/gtk-dark.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };

    xdg.configFile."niri/config.kdl".source = ../../../non-nixlang/niri-config.kdl;
    xdg.configFile."niri/noctalia.kdl".source = ../../../non-nixlang/niri-noctalia-colors.kdl;
  };
}
