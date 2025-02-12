{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_9,
  prisma-engines,
  sentry-cli,
  makeWrapper,
}:

let
  environment = {
    NEXT_TELEMETRY_DISABLED = "1";
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines "schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines "query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
    PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines "introspection-engine";
    PRISMA_FMT_BINARY = lib.getExe' prisma-engines "prisma-fmt";
    SENTRY_BINARY = lib.getExe sentry-cli;
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tegon";
  version = "0.3.9-alpha";

  src = fetchFromGitHub {
    owner = "tegonhq";
    repo = "tegon";
    rev = finalAttrs.version;
    hash = "sha256-hn0+HyHWq+E81VzPKQzvLVznmBbpyOxSaUEQ8R6I51M=";
  };

  patches = [
    ./0001-disable-lint.patch
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-j5BXib7LzJvg94dbYrSxRtxmDIcBwXLcg3RGPfmdBqQ=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    makeWrapper
  ];

  env = environment;

  buildPhase = ''
    runHook preBuild

    export PATH="$PWD/packages/cli/node_modules/.bin:$PATH"
    export NODE_ENV "production"
    pnpm --filter ./packages/types run build
    pnpm --filter ./packages/services run build
    pnpm --filter ./packages/ui run build
    pnpm --filter ./apps/server run build
    pnpm --filter ./apps/webapp run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    mv node_modules packages apps $out/lib

    makeWrapper ${lib.getExe pnpm_9} "$out/bin/tegon" \
      --chdir "$out/lib/apps/server" \
      --set NODE_PATH "$out/lib/node_modules/.pnpm/node_modules" \
      --set PATH "${lib.makeBinPath [ nodejs pnpm_9 ]}" \
      ${
        lib.concatStringsSep " " (
          lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") environment
        )
      } \
      --add-flags start-prod-with-prisma

    runHook postInstall
  '';

  dontFixup = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The dev-first issue tracking tool. Open-source, customisable and lightweight.";
    homepage = "www.tegon.ai";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ners ];
  };
})
