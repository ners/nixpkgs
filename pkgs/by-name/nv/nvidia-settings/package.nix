{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, gnum4
, gtk2
, gtk3
, jansson
, libvdpau
, vulkan-headers
, wayland-scanner
, xorg
}:

stdenv.mkDerivation {
  pname = "nvidia-settings";
  version = "560.35.03";
  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-settings";
    rev = "a6e6c02447676a9e691cf79884fd5790afbe3e49";
    hash = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
  };
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    gnum4
    gtk2
    gtk3
    jansson
    libvdpau.dev
    vulkan-headers
    wayland-scanner
    xorg.libXv.dev
    xorg.libXxf86vm.dev
  ];
  enableParallelBuilding = true;
  env.NV_USE_BUNDLED_LIBJANSSON = "0";

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    install -D -m644 doc/nvidia-settings.desktop "$out/share/applications/nvidia-settings.desktop"
    install -D -m644 doc/nvidia-settings.png "$out/share/pixmaps/nvidia-settings.png"
    sed \
      -e "s:__UTILS_PATH__:$out/bin:" \
      -e "s:__PIXMAP_PATH__:$out/share/pixmaps:" \
      -e 's/__NVIDIA_SETTINGS_DESKTOP_CATEGORIES__/Settings;HardwareSettings;/' \
      -e 's/Icon=.*/Icon=nvidia-settings/' \
      -i "$out/share/applications/nvidia-settings.desktop"
  '';

  postFixup = ''
    patchelf $out/bin/nvidia-settings --add-rpath $out/lib
  '';

  meta = with lib; {
    description = "Tool for configuring the NVIDIA graphics driver";
    homepage = "https://github.com/NVIDIA/nvidia-settings";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ners ];
  };
}
