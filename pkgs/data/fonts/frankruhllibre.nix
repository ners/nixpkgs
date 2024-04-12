{ lib, buildFont, fetchFromGitHub }:

buildFont {
  pname = "frankruhllibre";
  src = fetchFromGitHub {
    owner = "fontef";
    repo = "frankruhllibre";
    rev = "2372d1998e51dc011f86554c0d23f1ccf44afddf";
    hash = "sha256-d4tM21dj+fiejkmRShmZmo1NbsM0R6NtC8tmzIoRaPY=";
  };
  subdir = "fonts";
  meta = {
    description = "An open source version of the classic Hebrew Frank Rühl typeface";
    homepage = "https://github.com/fontef/frankruhllibre/";
    license = lib.licenses.ofl;
    longDescription = ''
      The most ubiquitous Hebrew typeface in print, Frank Rühl was designed in 1908 by Rafael Frank in collaboration with Auto Rühl of the C. F. Rühl foundry of Leipzig. A final version was released in 1910. Many Israeli books, newspapers and magazines use Frank Rühl as their main body text typeface.

      Made to accommodate the growing need for typefaces in secular Hebrew writings, the typeface was fitted to modern printing demands and designed to be readable in longform text, with and without vowel marks.

      Frank Rühl has Sephardi proportions (mem-height is approximately 4½ stroke widths), and is based roughly on Venetian typefaces used by printer Daniel Bomberg. Frank wrote of his design that he wishes to combine the simpleness of Antiqua with the "pleasantness" of Fraktur, leading him to "quieten" the letterforms by reducing the contrast between its thin and thick strokes.

      This newly designed revival of the typeface features a family of 5 weights (the original typeface had only one.)
    '';
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.all;
  };
}
