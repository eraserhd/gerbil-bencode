{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };
in {
  test = pkgs.stdenv.mkDerivation {
    name = "gerbil-bencode-tests";

    src = ./.;
    buildInputs = [ pkgs.gerbil ];

    buildPhase = ''
      gxi run-tests.ss
    '';
    installPhase = ''
      mkdir -p $out
    '';
  };
}
