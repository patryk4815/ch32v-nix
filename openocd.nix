{
   pkgs ? (import (builtins.getFlake "github:nixos/nixpkgs/nixpkgs-unstable") {})
}:
let
    lib = pkgs.lib;
    final = (pkgs.openocd.override {
#      stdenv = pkgs.clang15Stdenv;
    }).overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [
        pkgs.autoreconfHook
      ];

      configureFlags = (old.configureFlags or []) ++ [
        "--enable-ch347"
        "--enable-wlinke"
        "--disable-werror"
      ];

      # Patch is generated from https://github.com/WCHSoftGroup/ch347/blob/main/OpenOCD_SourceCode_CH347/src/jtag/drivers/ch347.c
      # + added support for Apple
      patches = [
        ./openocd.patch
      ];

      src = pkgs.fetchFromGitHub {
          # https://github.com/jnk0le/openocd-wch
          owner = "jnk0le";
          repo = "openocd-wch";
          rev = "62850cbf873937e6d602154397788bccabc85052";  # "refs/heads/mrs-wch-riscv-230824-LIBERATED";
#          hash = lib.fakeHash;
          hash = "sha256-3g2XTHHKz/E4nhYJqlvZoWatfJ6AZPeLHmeZZ2s0qpY=";
      };
    });
in
    final
