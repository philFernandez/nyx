{ lib, pkgs, stdenv, fetchFromGitHub, nodejs-16_x }:

let
  metadata = import ./metadata.nix;

  nodePackages = import ./node-composition.nix {
    inherit pkgs;
    nodejs = nodejs-16_x;
  };

in
nodePackages.package
