{ pkgs ? import <nixpkgs> { } }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

in
pkgs.stdenv.mkDerivation rec {
  pname = "ormolu";

  version = "0.7.2.0";

  src =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchzip
        {
          url = "justin.gateway.scarf.sh/easy-ormolu-nix/macOS/0.7.2.0.zip";
          sha256 = "sSQxXnyc3QlfiKptDNhrVFMJJCLLzq8yLgXq9eUVeT8=";
          stripRoot = false;
        }
    else
      pkgs.fetchzip {
        url = "justin.gateway.scarf.sh/easy-ormolu-nix/Linux/0.7.2.0.zip";
        sha256 = "ceYFDFrNj4aoy3zKQr9h9cou+uq8KfZXzzwCIaJHOXs=";
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
