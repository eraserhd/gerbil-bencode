{ stdenv, lib, fetchFromGitHub, gerbil, gambit, ... }:

stdenv.mkDerivation rec {
  pname = "gerbil-bencode";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ gerbil gambit ];

  installPhase = ''
    mkdir -p $out/bin
    GERBIL_PATH=$out gxi build.ss
  '';

  meta = with lib; {
    description = "bencode library for Gerbil Scheme";
    homepage = "https://github.com/eraserhd/gerbil-bencode";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
