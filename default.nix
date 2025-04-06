{ pkgs ? import <nixpkgs> { } }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

in
pkgs.stdenv.mkDerivation rec {
  pname = "ormolu";

  version = "0.8.0.0";

  src =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchzip
        {
          url = "justin.gateway.scarf.sh/easy-ormolu-nix/aarch64-darwin/0.8.0.0.zip";
          sha256 = "1pn0qyix30m849jr56d9rbdjz0ljxhqkdiv99mfcq8kjnfbq8cnl";
          stripRoot = false;
        }
    else
      pkgs.fetchzip {
        url = "justin.gateway.scarf.sh/easy-ormolu-nix/x86_64-linux/0.8.0.0.zip";
        sha256 = "aHVz5S8ZEMMQkbSoZt16HZ/iDbIiXncsq2/tqS0+5jA=";
      };

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    ORMOLU=$out/bin/ormolu

    install -D -m555 -T ormolu $ORMOLU

    ${pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      cp $src/*.dylib $out/bin
    ''}

    mkdir -p $out/etc/bash_completion.d/
    $ORMOLU --bash-completion-script $ORMOLU > $out/etc/bash_completion.d/ormolu-completion.bash
  '';
}
