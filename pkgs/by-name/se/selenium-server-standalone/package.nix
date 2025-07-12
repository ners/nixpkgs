{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  htmlunit-driver,
  chromedriver,
  chromeSupport ? true,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "selenium-server-standalone";
  version = "4.34.0";

  src = fetchurl {
    url = "https://github.com/SeleniumHQ/selenium/releases/download/selenium-${finalAttrs.version}/selenium-server-${finalAttrs.version}.jar";
    sha256 = "sha256-xMp7JFOr7CiscFz8YTIbp+1i6Ib7/VTJl7Ez1zxpxQg=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share/lib/${finalAttrs.pname}-${finalAttrs.version}
    cp $src $out/share/lib/${finalAttrs.pname}-${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.jar
    makeWrapper ${jre}/bin/java $out/bin/selenium-server \
    --add-flags "-cp $out/share/lib/${finalAttrs.pname}-${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.jar:${htmlunit-driver}/share/lib/${htmlunit-driver.name}/${htmlunit-driver.name}.jar" \
      ${lib.optionalString chromeSupport "--add-flags -Dwebdriver.chrome.driver=${chromedriver}/bin/chromedriver"} \
      --add-flags "-jar" \
      --add-flags "$src" \
      --add-flags "standalone"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^selenium-([0-9.]+)$"
    ];
  };

  meta = with lib; {
    homepage = "http://www.seleniumhq.org/";
    description = "Selenium Server for remote WebDriver";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [
      coconnor
      offline
      ners
    ];
    mainProgram = "selenium-server";
    platforms = platforms.all;
  };
})
