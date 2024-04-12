{ lib, buildFont, fetchFromGitHub }:

buildFont {
  pname = "xanhmono";
  src = fetchFromGitHub {
    owner = "yellow-type-foundry";
    repo = "xanhmono";
    rev = "5c0ceb816ffc1e8f79be71c82a43201395f3eca5";
    hash = "sha256-XM4Ee8BjaNw+wGzHQuWD9rcPPEBmHu/sk7lRBZ/PHHc=";
  };
  subdir = "fonts";
  meta = {
    description = "Xanh Mono is a mono-serif typeface";
    longDescription = ''
      Xanh Mono is a mono-serif typeface, designed by Lam Bao & Duy Dao from the first digital type foundry in Vietnam, also known as Yellow Type Foundry. Xanh Mono is calm, gentle but still stylish enough to be used for both the reading experience and display purposes. Bao & Duy hopes Xanh Mono will be a great typography choice for you.
    '';
    homepage = "https://github.com/yellow-type-foundry/xanhmono";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.all;
  };
}
