{
  asmOptimizations ? clangStdenv.hostPlatform.isx86,
  clangStdenv,
  cmake,
  blas,
  fetchFromGitHub,
  git,
  lapack,
  lib,
  llvmPackages,
  lzo,
  openssl,
  perl,
  pkg-config,
  python3,
  snappy,
  yarn,
  withMkl ? false, mkl,
  targetArchitecture ? null,
  which,
  zlib,
}:

let
  defaultTargetArchitecture = if clangStdenv.hostPlatform.isx86 then "haswell" else "core";

  targetArch = if targetArchitecture == null then defaultTargetArchitecture else targetArchitecture;
in

clangStdenv.mkDerivation rec {
  pname = "arangodb";
  version = "3.12.4";

  src = fetchFromGitHub {
    repo = "arangodb";
    owner = "arangodb";
    rev = "v${version}";
    hash = "sha256-yVZzwPnbsKO48K0lVfSh0QNPcuml0MDWGWuJyfY2BWo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    perl
    pkg-config
    python3
    which
    yarn
  ];

  buildInputs = [
    blas
    lapack
    llvmPackages.openmp
    lzo
    openssl
    snappy
    zlib
  ] ++ lib.optional withMkl mkl;

  postPatch = ''
    #sed -i -e 's!/bin/echo!echo!' 3rdParty/V8/gypfiles/*.gypi

    # with nixpkgs, it has no sense to check for a version update
    substituteInPlace js/client/client.js --replace-fail "require('@arangodb').checkAvailableVersions();" ""
    substituteInPlace js/server/server.js --replace-fail "require('@arangodb').checkAvailableVersions();" ""

    substituteInPlace cmake/frontend/aardvark.cmake --replace-fail "COMMAND yarn " "COMMAND yarn --offline "
  '';

  preConfigure = ''
    patchShebangs utils
  '';

  enableParallelBuilding = false;

  cmakeFlags =
    [
      "-DUSE_MAINTAINER_MODE=OFF"
      "-DUSE_GOOGLE_TESTS=OFF"
      "-DBLAS_LIBRARIES=-lblas"
      "-DLAPACK_LIBRARIES=-llapack"

      # avoid reading /proc/cpuinfo for feature detection
      "-DTARGET_ARCHITECTURE=${targetArch}"
    ]
    ++ lib.optionals withMkl [
      "-DMKL_LIBRARIES=-lmkl"
    ]
    ++ lib.optionals asmOptimizations [
      "-DASM_OPTIMIZATIONS=ON"
      "-DFORCE_SSE42=${if clangStdenv.hostPlatform.sse4_2Support then "ON" else "OFF"}"
    ];

  meta = with lib; {
    homepage = "https://www.arangodb.com";
    description = "Native multi-model database with flexible data models for documents, graphs, and key-values";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      flosse
      jsoo1
      ners
    ];
  };
}
