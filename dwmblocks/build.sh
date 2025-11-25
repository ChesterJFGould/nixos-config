unset PATH

for p in $buildInputs; do
  export PATH=$p/bin${PATH:+:}$PATH
  export INCLUDE_FLAGS="-I $p/include $INCLUDE_FLAGS"
  export LOAD_FLAGS="-L $p/lib $LOAD_FLAGS"
  export PKG_CONFIG_PATH="$p/lib/pkgconfig:$PKG_CONFIG_PATH"
done

mkdir $out
mkdir $out/bin
mkdir $out/build

cp -r $files/* $out/build

cd $out/build
echo "$configHeader" > config.h
make
cp $out/build/dwmblocks $out/bin
