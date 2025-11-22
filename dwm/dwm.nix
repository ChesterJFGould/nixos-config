{ pkgs }:
derivation {
  name = "dwm";
  builder = "${pkgs.bash}";
  args = [ ./build.sh ];
  system = "x86_64-linux";
  buildInputs = with pkgs; [
    coreutils
  ];

}
