{
  pkgs ? (import (builtins.getFlake "github:nixos/nixpkgs/nixpkgs-unstable") { }),
}:
let
  lib = pkgs.lib;
  final =
    (pkgs.openocd.override {
      #      stdenv = pkgs.clang15Stdenv;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkgs.autoreconfHook
        ];

        configureFlags = (old.configureFlags or [ ]) ++ [
          "--enable-picoprobe"
          "--enable-cmsis-dap"
          "--disable-werror"
        ];

        src = pkgs.fetchFromGitHub {
          owner = "raspberrypi";
          repo = "openocd";
          rev = "cd4873400c881ce3019c74620afb19e964a1f235";
          hash = "sha256-lQugY+dUdvfFGGj1Sf0a5KzOzHJhdQfhyE/xFxx5Ouc=";
        };
      });
in
final
