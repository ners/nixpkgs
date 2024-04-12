{ lib, buildFont, fetchFromGitHub }:

buildFont {
  pname = "akshar";
  src = fetchFromGitHub {
    owner = "tallchai";
    repo = "akshar-type";
    rev = "703a8e549e5691fd35eaa4b94983a7d3bdd7190a";
    hash = "sha256-QTBRfHGY7Wd09O5mtTSL9mwpXJ0j6a5KOag4V8SRyb0=";
  };
  subdir = "fonts";
  meta = {
    description = "A variable display sans-serif font family that supports Latin and Devanagari";
    homepage = "https://github.com/tallchai/akshar-type";
    license = lib.licenses.ofl;
    longDescription = ''
      Akshar is a variable display sans-serif font family that supports Latin and Devanagari. It is designed for titles, statements, headlines, annoucements, intros, outros, and other display texts. Akshar (Hindi: अक्षर) literally means an alphabet or a letter in Hindi, Marathi, Gujarati and other Indic languages.
    '';
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.all;
  };
}
