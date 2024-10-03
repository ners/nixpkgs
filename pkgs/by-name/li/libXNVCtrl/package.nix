{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, xorg
}:

stdenv.mkDerivation rec {
  pname = "libXNVCtrl";
  version = "560.35.03";
  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-settings";
    rev = "a6e6c02447676a9e691cf79884fd5790afbe3e49";
    hash = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
  };
  patches = [
    ./0001-libxnvctrl_so.patch
  ];
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    xorg.libX11.dev
    xorg.libXext.dev
  ];
  enableParallelBuilding = true;

  sourceRoot = "${src.name}/src/libXNVCtrl";

  installPhase = ''
    mkdir -p $out/include $out/lib
    install -Dm 644 *.h -t "$out/include/NVCtrl"
    cp -Pr _out/*/libXNVCtrl.* -t "$out/lib"
  '';

  meta = with lib; {
    description = "NVIDIA NV-CONTROL X extension";
    homepage = "https://github.com/NVIDIA/nvidia-settings";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ners ];
  };
}
