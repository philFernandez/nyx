_final: prev:

let
  rev = "c539e0e4350a42f813952fc28dd8490f42d934b3";
  sha256 = "sha256-EDAL7NnLF2BiVI8DAlEciiZtDmwXOzCPypGTrlN/OoQ=";
in
{
  awesome-git = prev.awesome.overrideAttrs (
    old: rec {
      version = "4.3-git";
      src = prev.fetchFromGitHub {
        owner = "awesomewm";
        repo = "awesome";
        rev = rev;
        sha256 = sha256;
      };
    }
  );
}
