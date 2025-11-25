{ pkgs }:
let
  fs = pkgs.lib.fileset;
in
derivation {
  name = "st";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./build.sh ];
  system = "x86_64-linux";
  buildInputs = with pkgs; [
    coreutils
    bash
    gcc
    gnumake
    freetype.dev
    freetype
    fontconfig.out
    fontconfig.bin
    fontconfig.dev
    fontconfig.lib
    pkg-config
    xorg.libX11.dev
    xorg.libX11
    xorg.libXft.dev
    xorg.libXft
    xorg.libXrender.dev
    xorg.libXrender
    xorg.libXinerama.dev
    xorg.libXinerama
    xorg.libxcb.dev
    xorg.libxcb
    xorg.xorgproto
  ];
  files = fs.toSource {
    root = ./.;
    fileset = fs.union ./Makefile (fs.fileFilter (file: file.hasExt "h" || file.hasExt "c" || file.hasExt "mk") ./.);
  };
}
