{ lib, buildFont, fetchFromGitHub }:

buildFont {
  pname = "radley";
  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "RadleyFont";
    rev = "e313d03c7eb784010b95e179bb41212106d40b80";
    hash = "sha256-66zBfs7JhMCeB1MQioVedQRDIPCq69M9/3uVroMo3as=";
  };
  subdir = "fonts";
  meta = {
    longDescription = ''
      Radley is based on lettering originally drawn and designed for woodcarved titling work. It was later digitized and extended to be used on the web. Radley is a practical face, based on letterforms used by hand carvers who cut letters quickly, efficiently, and with style. It can be used for both titling and text typography.

      The basic letterforms in Radley grew out of sketching and designing directly into wood with traditional carving chisels. These were scanned and traced into FontForge and cleaned up digitally, then the character set was expanded. There is something unique about carving letters into wood with traditional hand tools, and hopefully Radley carries some of the original spirit of these hand carved letterforms.

      Since the initial launch in 2012, Radley was updated by Vernon Adams adding an Italic and support for more Latin languages. He made many glyph refinements throughout the family based on user feedback. In 2017 the family was updated by Marc Foley to complete the work started by Vernon.
    '';
    homepage = "https://fonts.google.com/specimen/Radley";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.all;
  };
}
