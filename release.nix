{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };
  gerbil-bencode = pkgs.callPackage ./derivation.nix {};
in {
  test = pkgs.runCommandNoCC "gerbil-bencode-test" {} ''
    mkdir -p $out
    : ${pkgs.gerbil-bencode}
  '';
}