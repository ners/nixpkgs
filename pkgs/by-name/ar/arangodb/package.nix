{
  # Does not build with GCC anymore: https://github.com/arangodb/arangodb/issues/20586
  clangStdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  abseil-cpp,
  blas,
  boost178,
  cmake,
  faiss,
  gtest,
  icu,
  lapack,
  llhttp,
  llvmPackages,
  lz4,
  nghttp2,
  openssl,
  perl,
  python3,
  rocksdb,
  velocypack,
  git,
  which,
  zlib,
  targetArchitecture ? null,
  asmOptimizations ? clangStdenv.hostPlatform.isx86,
}:

let
  defaultTargetArchitecture = if clangStdenv.hostPlatform.isx86 then "haswell" else "core";

  targetArch = if targetArchitecture == null then defaultTargetArchitecture else targetArchitecture;

  version = "3.12.4";
  src = fetchFromGitHub {
    repo = "arangodb";
    owner = "arangodb";
    rev = "v${version}";
    hash = "sha256-xFawKNtAREESHA2x6F4nZiOiMucfW4+kn94MTtuu05I=";
  };

  fuerte = clangStdenv.mkDerivation {
    pname = "arangodb-fuerte";
    inherit version src;
    nativeBuildInputs = [
      cmake
    ];
    buildInputs = [
      abseil-cpp
      boost178
      llhttp
      nghttp2
      openssl
      velocypack
    ];
    preConfigure = ''
      cd 3rdParty/fuerte
      cat >> CMakeLists.txt <<EOF

      install(TARGETS fuerte DESTINATION lib)
      install(
        DIRECTORY   "include/fuerte"
        DESTINATION include
      )
      include(CPack)
      EOF
    '';
  };
in

clangStdenv.mkDerivation {
  pname = "arangodb";
  inherit version src;

  nativeBuildInputs = [
    cmake
    git
    perl
    pkg-config
    (python3.withPackages (ps: with ps; [ distutils ]))
    which
  ];

  buildInputs = [
    abseil-cpp
    blas
    faiss
    fuerte
    gtest
    icu
    lapack
    llvmPackages.openmp
    lz4
    openssl
    rocksdb
    zlib
  ];

  postPatch = ''
    find . -type f \( -name '*.h' -or -name '*.cpp' \) -exec sed -i 's/_64_64//g' {} \;
    patchShebangs utils
    substituteInPlace CMakeLists.txt --replace-fail 'add_subdirectory(3rdParty' '# add_subdirectory(3rdParty'
  '';

  enableParallelBuilding = true;

  # cmakeBuildType = "RelWithDebInfo";

  cmakeFlags =
    [
      "-DBLAS_LIBRARIES=-lblas"
      "-DLAPACK_LIBRARIES=-llapack"

      # do not suffix ICU functions with _64_64
      "-DU_HAVE_LIB_SUFFIX=0"
      "-DU_LIB_SUFFIX_C_NAME="

      # whether we want to have assertions and other development features
      "-DUSE_MAINTAINER_MODE=OFF"

      # skip building the web frontend with cmake, we build it ourselves
      "-DUSE_FRONTEND=OFF"

      # avoid reading /proc/cpuinfo for feature detection
      "-DTARGET_ARCHITECTURE=${targetArch}"
    ]
    ++ lib.optionals asmOptimizations [
      "-DASM_OPTIMIZATIONS=ON"
      "-DFORCE_SSE42=${if clangStdenv.hostPlatform.sse4_2Support then "ON" else "OFF"}"
    ];

  meta = with lib; {
    homepage = "https://www.arangodb.com";
    description = "Native multi-model database with flexible data models for documents, graphs, and key-values";
    license = licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with maintainers; [
      flosse
      jsoo1
      ners
    ];
  };
}
