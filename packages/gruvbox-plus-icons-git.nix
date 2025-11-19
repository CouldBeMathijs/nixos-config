{ lib, stdenvNoCC, gruvbox-icons, gtk3, plasma5Packages, gnome-icon-theme, hicolor-icon-theme, system }:

stdenvNoCC.mkDerivation rec {
        pname = "gruvbox-plus-icons-git";
        version = gruvbox-icons.lastModifiedDate;
        src = gruvbox-icons;

        nativeBuildInputs = [ gtk3 ];

        propagatedBuildInputs = [
                plasma5Packages.breeze-icons
                gnome-icon-theme
                hicolor-icon-theme
        ];

        installPhase = ''
  runHook preInstall

  # Copy the theme to a temporary, writable directory
  cp -r Gruvbox-Plus-Dark $TMPDIR/

  # Update the icon cache in the temporary directory
  gtk-update-icon-cache $TMPDIR/Gruvbox-Plus-Dark

  # Copy the complete theme (with the cache file) to the output directory
  mkdir -p $out/share/icons/
  cp -r $TMPDIR/Gruvbox-Plus-Dark $out/share/icons/

  runHook postInstall
        '';
        dontDropIconThemeCache = false;
        dontBuild = true;
        dontConfigure = true;

        meta = {
                description = "Icon pack for Linux desktops based on the Gruvbox color scheme";
                homepage = "https://github.com/SylEleuth/gruvbox-plus-icon-pack";
                license = lib.licenses.gpl3Only;
                platforms = lib.platforms.linux;
                maintainers = with lib.maintainers; [
                        eureka-cpu
                        Gliczy
                ];
        };
}
