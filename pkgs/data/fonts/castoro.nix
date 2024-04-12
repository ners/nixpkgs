{ lib, buildFont, fetchFromGitHub }:

buildFont {
  pname = "castoro";
  src = fetchFromGitHub {
    owner = "TiroTypeworks";
    repo = "Castoro";
    rev = "7dde0fad4636c40ae5bae63f723b4986c7f758d6";
    hash = "sha256-GT9ZAnQG4hmRccJ6HdygaHMf4QDh+3L5vyZFa6MnOPk=";
  };
  subdir = "fonts";
  meta = {
    homepage = "https://github.com/TiroTypeworks/Castoro";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.all;
  };
}
