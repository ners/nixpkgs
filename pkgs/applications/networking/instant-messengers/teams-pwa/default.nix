{ chromium
, google-chrome
, microsoft-edge
, brave
, copyDesktopItems
, makeDesktopItem
, stdenv
, lib
, fetchurl
}:

let
  mkTeamsForBrowser = (browser:
    let
      browserName = browser.pname;
    in
    stdenv.mkDerivation (final: {
      name = "teams-pwa-${browserName}";
      nativeBuildInputs = [ copyDesktopItems ];
      dontUnpack = true;

      desktopItems = [
        (makeDesktopItem {
          name = final.name;
          exec = "${browser}/bin/${browser.meta.mainProgram or browserName} --app=https://teams.microsoft.com";
          icon = fetchurl {
            url = "https://statics.teams.cdn.office.net/hashed/favicon/prod/favicon-f1722d9.ico";
            hash = "sha256-OX7d9E4b9+VXsLT1Fz2pXY/YMrby8Q1uQcF9xTnVqCI=";
          };
          desktopName = "Microsoft Teams PWA";
          genericName = "Progressive Web App for Microsoft Teams";
          categories = [ "Network" ];
          mimeTypes = [ "x-scheme-handler/msteams" ];
        })
      ];

      meta = with lib; {
        description = "Microsoft Teams PWA";
        homepage = "https://teams.microsoft.com";
        maintainers = with maintainers; [ vlot ];
        platforms = browser.meta.platforms;
        license = browser.meta.license;
      };
    })
  );
in
{
    chromium = mkTeamsForBrowser chromium;
    google-chrome =  mkTeamsForBrowser google-chrome;
    brave = mkTeamsForBrowser brave;
    microsoft-edge =  mkTeamsForBrowser microsoft-edge;
}
