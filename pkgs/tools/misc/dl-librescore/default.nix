{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
}:

buildNpmPackage rec {
  pname = "dl-librescore";
  version = "0.34.46";

  src = fetchFromGitHub {
    owner = "LibreScore";
    repo = "dl-librescore";
    rev = "v${version}";
    hash = "sha256-ONgsDeOgrK+4WbiwOpbcmhG7JCaJTHhIw1ZZuLxEirE=";
  };

  forceGitDeps = true;

  npmDepsHash = "sha256-yhEQ5bnIj0MEZA8NFqtogEmRQQP9hJ+eGl2VZC3rlzY=";

  nativeBuildInputs = [ makeWrapper ];

  dontNpmBuild = true;

  meta = with lib; {
    description = "Download sheet music";
    homepage = "https://github.com/LibreScore/dl-librescore";
    license = licenses.mit;
    maintainers = with maintainers; [ ners ];
  };
}
