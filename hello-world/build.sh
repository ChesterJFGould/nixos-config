unset PATH
for p in $buildInputs; do
    export PATH=$p/bin${PATH:+:}$PATH
done

mkdir $out
mkdir $out/bin
gcc $src -o $out/bin/hello-world
