{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  gtk3,
  glib,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zigenity";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "r4gus";
    repo = "zigenity";
    tag = finalAttrs.version;
    hash = "sha256-/QCRz53NwqcYHrVii/5TANIZ1d6ca0fJMOlPIowz2hc=";
  };

  nativeBuildInputs = [
    pkg-config
    zig.hook
  ];

  buildInputs = [
    gtk3
    glib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/r4gus/zigenity";
    description = "Like Zenity but in Zig";
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.linux;
  };
})
