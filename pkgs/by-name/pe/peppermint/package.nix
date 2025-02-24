{
  lib,
  cacert,
  stdenvNoCC,
  fetchFromGitHub,
  yarn-berry,
  nodejs,
  nix-update-script,
  openssl,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "peppermint";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "Peppermint-Lab";
    repo = "peppermint";
    rev = finalAttrs.version;
    hash = "sha256-kUvhukaiS5hSQ7tp98MRiAd0d8QeOMZ8+lHyav1xkS4=";
  };

  patches = [
    ./0001-update-yarn.patch
    ./0002-ignore-errors.patch
  ];

  yarnOfflineCache = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-yarn-deps";
    inherit (finalAttrs) version src patches;

    nativeBuildInputs = [
      nodejs
      python3
      yarn-berry
    ];

    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    YARN_ENABLE_TELEMETRY = "0";

    configurePhase = ''
      runHook preConfigure

      export HOME="$NIX_BUILD_TOP"

      yarn config set enableGlobalCache false
      yarn config set cacheFolder $out

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      mkdir -p $out
      yarn install --immutable

      runHook postBuild
    '';

    installPhase = ''
      mv node_modules $out
    '';

    dontFixup = true;

    outputHash = "sha256-DelDftRClX4Kse33AzIGDbl5DsV0VHPHZ0nZl5h1gts=";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    nodejs
    python3
    yarn-berry
  ];

  buildInputs = [
    openssl
  ];

  YARN_ENABLE_TELEMETRY = "0";
  NEXT_TELEMETRY_DISABLED = "1";

  configurePhase = ''
    runHook preConfigure

    export HOME="$NIX_BUILD_TOP"

    yarn config set enableGlobalCache false
    yarn config set cacheFolder $yarnOfflineCache

    cp -r $yarnOfflineCache/node_modules node_modules
    chmod 755 node_modules
    chmod -R u+w node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    for app in apps/*; do
      yarn workspace $(basename $app) install --immutable --immutable-cache --mode skip-build
      yarn workspace $(basename $app) build
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/apps
    cp -r apps/api $out/apps/api
    cp -r apps/client/.next/standalone/apps/client $out/apps/client
    mkdir -p $out/apps/client/.next
    cp -r apps/client/.next/static $out/apps/client/.next/static
    cp -r apps/client/public $out/apps/client/public
    cp -r ecosystem.config.js $out/ecosystem.config.js

    runHook postInstall
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An open source issue management & help desk solution";
    homepage = "https://peppermint.sh";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ners ];
    mainProgram = "peppermint";
  };
})
