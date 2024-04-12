{ lib, buildFont, fetchFromGitHub }:

buildFont {
  pname = "cinzel";
  src = fetchFromGitHub {
    owner = "NDISCOVER";
    repo = "cinzel";
    rev = "dd598495b0fb2ad84270d5cc75d642d2f1e8eabf";
    hash = "sha256-V3vSxe5eHN0BUplzmmBchzuV+gz36WfgZZezJ6NfaWg=";
  };
  subdir = "fonts";
  meta = {
    description = "Typeface inspired in First Century Roman Inscriptions";
    homepage = "https://github.com/NDISCOVER/Cinzel";
    license = lib.licenses.ofl;
    longDescription = ''
      Cinzel is a typeface inspired in first century roman inscriptions, and based on classical proportions. However it’s not a simple revivalism, while it conveys all the ancient history of the latin alphabet it also merges a contemporary feel onto it.
    '';
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.all;
  };
}
