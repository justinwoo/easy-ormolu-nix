{ pkgs ? import <nixpkgs> { } }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

in
pkgs.stdenv.mkDerivation rec {
  pname = "ormolu";

  version = "0.5.0.0";

  src =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchzip
        {
          url = "https://github.com/tweag/ormolu/releases/download/0.5.0.0/ormolu-macOS.zip";
          sha256 = "O3WJ2ZJoeCV/CBi4tvhhQ+g7wnALDFHuBhc9j2Xcv6k=";
          stripRoot = false;
        }
    else
      pkgs.fetchzip {
        url = "https://github.com/tweag/ormolu/releases/download/0.5.0.0/ormolu-Linux.zip";
        sha256 = "hOxJYv3iI31n8ghtZKl7o+Tj1JQiePhmMeaKJLTPLaE=";
      };

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    ORMOLU=$out/bin/ormolu
    install -D -m555 -T ormolu $ORMOLU

    ${pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      cp $src/*.dylib $out/bin
    ''}
  '';
}
