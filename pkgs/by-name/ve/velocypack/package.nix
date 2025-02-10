{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
}:

stdenv.mkDerivation {
  pname = "velocypack";
  version = "0.2.1-unstable-2024-09-27";
  src = fetchFromGitHub {
    owner = "arangodb";
    repo = "velocypack";
    rev = "bea8fc3afa7a9800a563f71c032519bae9d8477e";
    hash = "sha256-3zWzw0VmJSSSC95JSGKdLP0vowHHumN4XLY3GUDS7aM=";
  };

  nativeBuildInputs = [
    cmake
  ];
}
