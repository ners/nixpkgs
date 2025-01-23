{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  zig,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "passkeez";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "r4gus";
    repo = "keypass";
    tag = finalAttrs.version;
    hash = "sha256-YMjqiENZ7wX9hQnWDAypUpbwKzj+rEYoLnX9tW8NVl8=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [ zig.hook ];

  zigBuildFlags = [
    "--system"
    finalAttrs.deps
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/r4gus/keypass";
    description = "FIDO2/ Passkey compatible authenticator implementation for Linux";
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.linux;
  };
})
