{
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  git,
  icu,
  lz4,
  pkg-config,
  lib,
}:

stdenv.mkDerivation {
  pname = "iresearch";
  version = "unstable-2025-01-09";
  src = fetchFromGitHub {
    owner = "arangodb";
    repo = "iresearch";
    rev = "c24abc117de144291862349c2e281a76d252c1ff";
    hash = "sha256-FMZnQ6Zm/vIovC2ScquFVcc5NQr6UX4zc3EAts3nlNo=";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    boost
    icu
    lz4.dev
  ];

  cmakeFlags = [
    "-DLZ4_ROOT=${lz4.dev}"
    "-DLz4_SHARED_LIB=${lz4.lib}/liblz4.so"
    "-DLz4_STATIC_LIB=${lz4.lib}/liblz4.a"
    "-DICU_ROOT=${icu.dev}"
  ];
}
