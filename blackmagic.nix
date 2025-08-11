{
   pkgs ? (import (builtins.getFlake "github:nixos/nixpkgs/nixpkgs-unstable") {})
}:
let
    # https://github.com/blackmagic-debug/blackmagic/pull/1399
    lib = pkgs.lib;
    final = pkgs.blackmagic.overrideAttrs (old: {
      version = "1.10.0";
      src = pkgs.fetchFromGitHub {
          owner = "perigoso";
          repo = "blackmagic";
          rev = "a0daa1d0c635a8ab49f205aee7bddc31fc2bcf6f";  # feature/wch-link-support
          hash = "sha256-0sdwJ3CA8iPy2w2gjVys+mTkb/bhgG1FTt7VEaDDzyw=";
      };
      mesonFlags = [ "-Drvswd_support=true" ];
    });
in
    final
