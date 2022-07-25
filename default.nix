{ pkgs ? import <nixpkgs> { } }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

in
pkgs.stdenv.mkDerivation rec {
  pname = "ormolu";

  version = "0.5.0.0";

  src =
    pkgs.fetchzip {
      url = "https://github.com/tweag/ormolu/releases/download/0.5.0.0/ormolu-Linux.zip";
      sha256 = "hOxJYv3iI31n8ghtZKl7o+Tj1JQiePhmMeaKJLTPLaE=";
    };

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    ORMOLU=$out/bin/ormolu
    install -D -m555 -T ormolu $ORMOLU
  '';
}
