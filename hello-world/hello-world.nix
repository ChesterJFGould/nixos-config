{ pkgs }:

derivation {
  name = "hello-name";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./build.sh ];
  system = "x86_64-linux";
  buildInputs = with pkgs; [
    coreutils
    gcc
  ];
  src = ./hello-world.c;

}
