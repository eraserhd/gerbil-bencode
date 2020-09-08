{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };
in {
  test = pkgs.runCommandNoCC "gerbil-bencode-test" {} ''
    mkdir -p $out
    : ${pkgs.gerbilPackages.gerbil-bencode}
  '';
}
