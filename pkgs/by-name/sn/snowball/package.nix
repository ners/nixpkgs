{
  stdenv,
  fetchFromGitHub,
  perl,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snowball";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qXrypwv/I+5npvGHGsHveijoui0ZnoGYhskCfLkewVE=";
  };

  nativeBuildInputs = [
    perl
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs libstemmer
    cat <<'EOF' >> GNUmakefile

    prefix ?= /usr/local

    install: snowball$(EXEEXT) libstemmer.a stemwords$(EXEEXT) $(C_OTHER_SOURCES) $(C_OTHER_HEADERS) $(C_OTHER_OBJECTS)
    	install -Dm755 snowball$(EXEEXT) stemwords$(EXEEXT) -t $(prefix)/bin
    	install -Dm755 $(C_OTHER_OBJECTS) -t $(prefix)/lib
    	install -Dm644 libstemmer.a -t $(prefix)/lib
    	install -Dm644 $(C_OTHER_HEADERS) -t $(prefix)/include
    EOF
  '';

  makeFlags = [
    "prefix=$(out)"
  ];

  preBuild = ''
    make algorithms.mk
  '';

  makeTargets = [ "all" ];
})
