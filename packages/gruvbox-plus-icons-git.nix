{
  gruvbox-icons,
  gtk3,
  hicolor-icon-theme,
  kdePackages,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-plus-icons-git";
  version = gruvbox-icons.lastModifiedDate or "latest";
  src = gruvbox-icons;

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    kdePackages.breeze-icons
    hicolor-icon-theme
  ];

  dontBuild = true;
  dontConfigure = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/Gruvbox-Plus-Dark
    cp -r Gruvbox-Plus-Dark/* $out/share/icons/Gruvbox-Plus-Dark/

    # Generate cache here
    gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark
    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "Icon pack for Linux desktops based on the Gruvbox color scheme";
    homepage = "https://github.com/SylEleuth/gruvbox-plus-icon-pack";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ CouldBeMathijs ];
  };
}
